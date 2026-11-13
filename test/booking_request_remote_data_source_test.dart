import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/features/booking_request/data/data_source/booking_request_remote_data_source.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/features/booking_request/data/models/busy_range.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: subtype_of_sealed_class
class _FakeDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic>? _data;

  _FakeDocumentSnapshot(this._data);

  @override
  Map<String, dynamic>? data() => _data;

  @override
  bool get exists => _data != null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirestoreService implements FirestoreService {
  Map<String, dynamic>? busySlotsDoc;
  String? requestedCollection;
  String? requestedDocId;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({
    required String collection,
    required String docId,
  }) async {
    requestedCollection = collection;
    requestedDocId = docId;
    return _FakeDocumentSnapshot(busySlotsDoc);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _single = BookingModel(
  id: '',
  coachUid: 'coach1',
  traineeUid: 'trainee1',
  sport: 'football',
  trainingLocation: 'Club A',
  date: '2030-03-02',
  startTime: '18:00',
  endTime: '19:00',
  price: 1, // ignored by the server
  notes: 'hi',
);

/// The busy-slot calculation itself runs in the Cloud Function
/// (functions/src/utils/busy_slots.ts) and is tested there; these tests
/// cover how the app reads `coach_busy_slots` and calls `createBooking`.
void main() {
  late _FakeFirestoreService fakeFirestore;
  late BookingRequestRemoteDataSource dataSource;
  late List<(String, Map<String, dynamic>)> calls;
  late Future<Map<String, dynamic>> Function() answer;

  setUp(() {
    fakeFirestore = _FakeFirestoreService();
    calls = [];
    answer = () async => {'bookingId': 'new_id', 'price': 50};
    dataSource = BookingRequestRemoteDataSource(
      firestoreService: fakeFirestore,
      callFunction: (name, data) {
        calls.add((name, data));
        return answer();
      },
      utcOffset: () => const Duration(hours: 3),
    );
  });

  group('getBusyRanges', () {
    test('reads start-end ranges from the coach busy-slots document', () async {
      fakeFirestore.busySlotsDoc = {
        'slots': {'2026-11-12': ['11:00']},
        'ranges': {
          '2026-11-12': ['11:00-12:30', '15:00-16:00'],
          '2026-11-13': ['09:00-10:00'],
        },
      };

      final ranges = await dataSource.getBusyRanges(coachUid: 'coach1', date: '2026-11-12');

      expect(fakeFirestore.requestedCollection, AppConstants.coachBusySlotsCollection);
      expect(fakeFirestore.requestedDocId, 'coach1');
      expect(ranges, const [BusyRange(660, 750), BusyRange(900, 960)]);
    });

    test('older documents (start times only) assume one session length', () async {
      fakeFirestore.busySlotsDoc = {
        'slots': {'2026-11-12': ['11:00']},
      };

      final ranges = await dataSource.getBusyRanges(
        coachUid: 'coach1',
        date: '2026-11-12',
        fallbackDurationMinutes: 45,
      );

      expect(ranges, const [BusyRange(660, 705)]);
    });

    test('no document, or no entry for the day -> nothing busy', () async {
      fakeFirestore.busySlotsDoc = null;
      expect(await dataSource.getBusyRanges(coachUid: 'c', date: '2026-11-12'), isEmpty);

      fakeFirestore.busySlotsDoc = {'ranges': {'2026-11-13': ['09:00-10:00']}};
      expect(await dataSource.getBusyRanges(coachUid: 'c', date: '2026-11-12'), isEmpty);
    });

    test('ignores malformed data', () async {
      fakeFirestore.busySlotsDoc = {
        'ranges': {
          '2026-11-12': ['10:00-11:00', 42, '', null, '12:00', '13:00-12:00'],
          '2026-11-13': 'not-a-list',
        },
      };

      expect(
        await dataSource.getBusyRanges(coachUid: 'c', date: '2026-11-12'),
        const [BusyRange(600, 660)],
      );
      expect(await dataSource.getBusyRanges(coachUid: 'c', date: '2026-11-13'), isEmpty);
    });
  });

  group('createBooking', () {
    test('sends only the choices to the server and returns its id and price', () async {
      final created = await dataSource.createBooking(_single);

      expect(created.id, 'new_id');
      expect(created.price, 50);
      final (name, data) = calls.single;
      expect(name, 'createBooking');
      expect(data['coachUid'], 'coach1');
      expect(data['bookingType'], 'session');
      expect(data['trainingLocation'], 'Club A');
      expect(data['sessions'], [
        {'date': '2030-03-02', 'startTime': '18:00'},
      ]);
      expect(data['utcOffsetMinutes'], 180);
      expect(data.containsKey('price'), isFalse, reason: 'the server sets the price');
      expect(data.containsKey('traineeUid'), isFalse, reason: 'the server uses the signed-in user');
    });

    test('monthly: sends every session', () async {
      await dataSource.createBooking(_single.copyWith(
        bookingType: 'monthly',
        sessions: const [
          BookingSessionModel(id: 'a', date: '2030-03-02', startTime: '18:00', endTime: '19:00'),
          BookingSessionModel(id: 'b', date: '2030-03-03', startTime: '17:00', endTime: '18:00'),
        ],
      ));

      expect(calls.single.$2['sessions'], [
        {'date': '2030-03-02', 'startTime': '18:00'},
        {'date': '2030-03-03', 'startTime': '17:00'},
      ]);
    });

    test('a refusal carries the reason and the clashing time', () async {
      answer = () async => throw FirebaseFunctionsException(
            message: 'slot_taken',
            code: 'failed-precondition',
            details: {
              'reason': 'slot_taken',
              'conflict': {'date': '2030-03-02', 'startTime': '18:00'},
            },
          );

      await expectLater(
        dataSource.createBooking(_single),
        throwsA(isA<BookingRequestException>()
            .having((e) => e.reason, 'reason', 'slot_taken')
            .having((e) => e.conflictDate, 'date', '2030-03-02')
            .having((e) => e.conflictStartTime, 'time', '18:00')),
      );
    });

    test('no connection -> "network"', () async {
      answer = () async => throw FirebaseFunctionsException(message: 'x', code: 'unavailable');

      await expectLater(
        dataSource.createBooking(_single),
        throwsA(isA<BookingRequestException>().having((e) => e.reason, 'reason', 'network')),
      );
    });
  });
}
