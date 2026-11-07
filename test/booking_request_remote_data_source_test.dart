import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/features/booking_request/data/data_source/booking_request_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: subtype_of_sealed_class
class _FakeQueryDocumentSnapshot
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;
  @override
  final String id;

  _FakeQueryDocumentSnapshot(this.id, this._data);

  @override
  Map<String, dynamic> data() => _data;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ignore: subtype_of_sealed_class
class _FakeQuerySnapshot implements QuerySnapshot<Map<String, dynamic>> {
  @override
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  _FakeQuerySnapshot(this.docs);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirestoreService implements FirestoreService {
  List<Map<String, dynamic>> singleDocs = [];
  List<Map<String, dynamic>> proposedDocs = [];
  List<Map<String, dynamic>> monthlyDocs = [];
  int callIndex = 0;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
    queryBuilder,
  }) async {
    final docs = switch (callIndex % 3) {
      0 => singleDocs,
      1 => proposedDocs,
      2 => monthlyDocs,
      _ => <Map<String, dynamic>>[],
    };
    callIndex++;
    return _FakeQuerySnapshot(
      docs.map((d) => _FakeQueryDocumentSnapshot(d['id'] ?? 'doc', d)).toList(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeFirestoreService fakeFirestore;
  late BookingRequestRemoteDataSource dataSource;

  setUp(() {
    fakeFirestore = _FakeFirestoreService();
    dataSource = BookingRequestRemoteDataSource(
      firestoreService: fakeFirestore,
    );
  });

  group('BookingRequestRemoteDataSource.getBookedSlots', () {
    test(
      'single booking: keeps original slot booked even when reschedule_pending',
      () async {
        fakeFirestore.singleDocs = [
          {
            'id': 'b1',
            'status': 'reschedule_pending',
            'date': '2026-11-10',
            'startTime': '10:00',
          },
        ];
        fakeFirestore.proposedDocs = [];
        fakeFirestore.monthlyDocs = [];

        final slots = await dataSource.getBookedSlots(
          coachUid: 'coach1',
          date: '2026-11-10',
        );

        expect(slots, contains('10:00'));
      },
    );

    test(
      'single booking: blocks proposed slot on proposed date during reschedule_pending',
      () async {
        fakeFirestore.singleDocs = [];
        fakeFirestore.proposedDocs = [
          {
            'id': 'b1',
            'status': 'reschedule_pending',
            'proposedDate': '2026-11-12',
            'proposedStartTime': '14:00',
          },
        ];
        fakeFirestore.monthlyDocs = [];

        final slots = await dataSource.getBookedSlots(
          coachUid: 'coach1',
          date: '2026-11-12',
        );

        expect(slots, contains('14:00'));
      },
    );

    test(
      'monthly booking: blocks proposed slot on proposed date when session is reschedule_pending',
      () async {
        fakeFirestore.singleDocs = [];
        fakeFirestore.proposedDocs = [];
        fakeFirestore.monthlyDocs = [
          {
            'id': 'mb1',
            'bookingType': 'monthly',
            'status': 'reschedule_pending',
            'sessions': [
              {
                'id': 's1',
                'date': '2026-11-05',
                'startTime': '09:00',
                'status': 'reschedule_pending',
                'proposedDate': '2026-11-12',
                'proposedStartTime': '15:00',
              },
              {
                'id': 's2',
                'date': '2026-11-12',
                'startTime': '11:00',
                'status': 'scheduled',
              },
            ],
          },
        ];

        final slots = await dataSource.getBookedSlots(
          coachUid: 'coach1',
          date: '2026-11-12',
        );

        // Should contain regular scheduled session (11:00) AND proposed session (15:00)
        expect(slots, contains('11:00'));
        expect(slots, contains('15:00'));
      },
    );

    test(
      'monthly booking: keeps original slot booked on original date when reschedule_pending',
      () async {
        fakeFirestore.singleDocs = [];
        fakeFirestore.proposedDocs = [];
        fakeFirestore.monthlyDocs = [
          {
            'id': 'mb1',
            'bookingType': 'monthly',
            'status': 'reschedule_pending',
            'sessions': [
              {
                'id': 's1',
                'date': '2026-11-05',
                'startTime': '09:00',
                'status': 'reschedule_pending',
                'proposedDate': '2026-11-12',
                'proposedStartTime': '15:00',
              },
            ],
          },
        ];

        final slots = await dataSource.getBookedSlots(
          coachUid: 'coach1',
          date: '2026-11-05',
        );

        expect(slots, contains('09:00'));
        expect(slots, isNot(contains('15:00')));
      },
    );

    test(
      'monthly booking: ignores cancelled sessions and cancelled/rejected bookings',
      () async {
        fakeFirestore.singleDocs = [];
        fakeFirestore.proposedDocs = [];
        fakeFirestore.monthlyDocs = [
          {
            'id': 'mb-cancelled',
            'bookingType': 'monthly',
            'status': 'cancelled',
            'sessions': [
              {
                'id': 's1',
                'date': '2026-11-10',
                'startTime': '10:00',
                'status': 'scheduled',
              },
            ],
          },
          {
            'id': 'mb-active',
            'bookingType': 'monthly',
            'status': 'confirmed',
            'sessions': [
              {
                'id': 's2',
                'date': '2026-11-10',
                'startTime': '12:00',
                'status': 'cancelled',
              },
              {
                'id': 's3',
                'date': '2026-11-10',
                'startTime': '16:00',
                'status': 'scheduled',
              },
            ],
          },
        ];

        final slots = await dataSource.getBookedSlots(
          coachUid: 'coach1',
          date: '2026-11-10',
        );

        expect(slots, isNot(contains('10:00')));
        expect(slots, isNot(contains('12:00')));
        expect(slots, contains('16:00'));
      },
    );
  });
}
