import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/features/coach_dashboard/data/data_source/coach_bookings_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: subtype_of_sealed_class
class _FakeDocSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final bool exists;
  @override
  final String id;
  final Map<String, dynamic>? _data;

  _FakeDocSnapshot(this.exists, this.id, this._data);

  @override
  Map<String, dynamic>? data() => _data;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirestoreService implements FirestoreService {
  final Map<String, Map<String, dynamic>> docs = {};
  String? updatedDocId;
  Map<String, dynamic>? updatedData;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({
    required String collection,
    required String docId,
  }) async {
    final data = docs[docId];
    if (data == null) {
      return _FakeDocSnapshot(false, docId, null);
    }
    return _FakeDocSnapshot(true, docId, data);
  }

  @override
  Future<void> updateData({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    updatedDocId = docId;
    updatedData = data;
    if (docs.containsKey(docId)) {
      docs[docId]!.addAll(data);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('CoachBookingsRemoteDataSource monthly session tests', () {
    late _FakeFirestoreService fakeFirestore;
    late CoachBookingsRemoteDataSource dataSource;

    setUp(() {
      fakeFirestore = _FakeFirestoreService();
      dataSource = CoachBookingsRemoteDataSource(firestoreService: fakeFirestore);
    });

    final testSession = BookingSessionModel(
      id: 'session-1',
      date: '2026-11-10',
      startTime: '10:00',
      endTime: '11:00',
      status: 'confirmed',
    );

    final testBooking = BookingModel(
      id: 'booking-1',
      coachUid: 'coach-1',
      traineeUid: 'trainee-1',
      sport: 'Boxing',
      date: '2026-11-10',
      startTime: '10:00',
      endTime: '11:00',
      bookingType: 'monthly',
      status: 'confirmed',
      sessions: [testSession],
    );

    test('requestMonthlySessionReschedule updates session proposal and status', () async {
      fakeFirestore.docs['booking-1'] = testBooking.toMap();

      await dataSource.requestMonthlySessionReschedule(
        bookingId: 'booking-1',
        sessionId: 'session-1',
        proposedDate: '2026-11-12',
        proposedStartTime: '14:00',
        proposedEndTime: '15:00',
        reason: 'Coach busy',
      );

      expect(fakeFirestore.updatedDocId, 'booking-1');
      expect(fakeFirestore.updatedData?['status'], 'reschedule_pending');
      final sessions = fakeFirestore.updatedData?['sessions'] as List<dynamic>;
      expect(sessions.length, 1);
      final firstSession = sessions.first as Map<String, dynamic>;
      expect(firstSession['proposedDate'], '2026-11-12');
      expect(firstSession['rescheduleReason'], 'Coach busy');
      expect(firstSession['rescheduledBy'], AppConstants.roleCoach);
    });

    test('acceptMonthlySessionReschedule confirms proposed time', () async {
      final proposedBooking = testBooking.proposeMonthlySessionReschedule(
        sessionId: 'session-1',
        proposedDate: '2026-11-12',
        proposedStartTime: '14:00',
        proposedEndTime: '15:00',
        reason: 'Trainee requested',
        rescheduledBy: AppConstants.roleTrainee,
      );
      fakeFirestore.docs['booking-1'] = proposedBooking.toMap();

      await dataSource.acceptMonthlySessionReschedule(
        bookingId: 'booking-1',
        sessionId: 'session-1',
      );

      expect(fakeFirestore.updatedDocId, 'booking-1');
      expect(fakeFirestore.updatedData?['status'], 'confirmed');
      final sessions = fakeFirestore.updatedData?['sessions'] as List<dynamic>;
      final firstSession = sessions.first as Map<String, dynamic>;
      expect(firstSession['date'], '2026-11-12');
      expect(firstSession['startTime'], '14:00');
    });

    test('markSessionCompleted updates session to completed and booking if all done', () async {
      fakeFirestore.docs['booking-1'] = testBooking.toMap();

      await dataSource.markSessionCompleted(
        bookingId: 'booking-1',
        sessionId: 'session-1',
      );

      expect(fakeFirestore.updatedDocId, 'booking-1');
      expect(fakeFirestore.updatedData?['status'], 'completed');
      final sessions = fakeFirestore.updatedData?['sessions'] as List<dynamic>;
      final firstSession = sessions.first as Map<String, dynamic>;
      expect(firstSession['status'], 'completed');
    });

    test('throws exception when booking is not found', () async {
      expect(
        () => dataSource.markSessionCompleted(
          bookingId: 'non-existent',
          sessionId: 'session-1',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
