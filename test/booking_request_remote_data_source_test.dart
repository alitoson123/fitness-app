import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/features/booking_request/data/data_source/booking_request_remote_data_source.dart';
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

/// The busy-slot calculation itself now runs in the Cloud Function
/// (functions/src/utils/busy_slots.ts) and is tested there; these tests
/// cover how the app reads the precomputed `coach_busy_slots` document.
void main() {
  late _FakeFirestoreService fakeFirestore;
  late BookingRequestRemoteDataSource dataSource;

  setUp(() {
    fakeFirestore = _FakeFirestoreService();
    dataSource = BookingRequestRemoteDataSource(firestoreService: fakeFirestore);
  });

  group('BookingRequestRemoteDataSource.getBookedSlots', () {
    test('reads the coach busy-slots document, not the bookings collection',
        () async {
      fakeFirestore.busySlotsDoc = {
        'slots': {
          '2026-11-12': ['11:00', '15:00'],
        },
      };

      final slots = await dataSource.getBookedSlots(
        coachUid: 'coach1',
        date: '2026-11-12',
      );

      expect(fakeFirestore.requestedCollection,
          AppConstants.coachBusySlotsCollection);
      expect(fakeFirestore.requestedDocId, 'coach1');
      expect(slots, ['11:00', '15:00']);
    });

    test('returns only the requested date', () async {
      fakeFirestore.busySlotsDoc = {
        'slots': {
          '2026-11-05': ['09:00'],
          '2026-11-12': ['11:00'],
        },
      };

      final slots = await dataSource.getBookedSlots(
        coachUid: 'coach1',
        date: '2026-11-05',
      );

      expect(slots, ['09:00']);
    });

    test('returns an empty list when the coach has no busy-slots document',
        () async {
      fakeFirestore.busySlotsDoc = null;

      final slots = await dataSource.getBookedSlots(
        coachUid: 'coach1',
        date: '2026-11-12',
      );

      expect(slots, isEmpty);
    });

    test('ignores malformed data', () async {
      fakeFirestore.busySlotsDoc = {
        'slots': {
          '2026-11-12': ['10:00', 42, '', null],
          '2026-11-13': 'not-a-list',
        },
      };

      expect(
        await dataSource.getBookedSlots(coachUid: 'c', date: '2026-11-12'),
        ['10:00'],
      );
      expect(
        await dataSource.getBookedSlots(coachUid: 'c', date: '2026-11-13'),
        isEmpty,
      );
    });
  });
}
