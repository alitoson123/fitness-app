import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingSessionModel & BookingModel Monthly Tests (Milestone 8)', () {
    test('BookingSessionModel serialization and deserialization with proposal fields', () {
      final now = DateTime(2026, 11, 4, 15, 30);
      final session = BookingSessionModel(
        id: 's_1',
        date: '2026-11-05',
        startTime: '10:00',
        endTime: '11:00',
        status: 'reschedule_pending',
        proposedDate: '2026-11-06',
        proposedStartTime: '12:00',
        proposedEndTime: '13:00',
        rescheduleReason: 'Emergency clinic duty',
        rescheduledBy: 'coach',
        rescheduledAt: now,
        previousDate: '2026-11-05',
        previousStartTime: '10:00',
        previousEndTime: '11:00',
      );

      final map = session.toMap();
      expect(map['id'], 's_1');
      expect(map['date'], '2026-11-05');
      expect(map['status'], 'reschedule_pending');
      expect(map['proposedDate'], '2026-11-06');
      expect(map['proposedStartTime'], '12:00');
      expect(map['proposedEndTime'], '13:00');
      expect(map['rescheduleReason'], 'Emergency clinic duty');
      expect(map['rescheduledBy'], 'coach');
      expect(map['previousDate'], '2026-11-05');

      final fromMap = BookingSessionModel.fromJson(map);
      expect(fromMap.id, session.id);
      expect(fromMap.proposedDate, session.proposedDate);
      expect(fromMap.rescheduledBy, 'coach');
      expect(fromMap.isReschedulePending, isTrue);
      expect(fromMap.canReschedule, isTrue);
      expect(fromMap.isCompleted, isFalse);
    });

    test('BookingSessionModel status transitions: propose, accept, decline, complete', () {
      const initial = BookingSessionModel(
        id: 's_1',
        date: '2026-11-05',
        startTime: '10:00',
        endTime: '11:00',
      );
      expect(initial.isScheduled, isTrue);
      expect(initial.canReschedule, isTrue);

      final proposed = initial.proposeReschedule(
        newDate: '2026-11-07',
        newStartTime: '14:00',
        newEndTime: '15:00',
        reason: 'Rainstorm expected',
        by: 'trainee',
      );
      expect(proposed.isReschedulePending, isTrue);
      expect(proposed.proposedDate, '2026-11-07');
      expect(proposed.previousDate, '2026-11-05');
      expect(proposed.rescheduledBy, 'trainee');

      final accepted = proposed.acceptReschedule();
      expect(accepted.status, 'scheduled');
      expect(accepted.date, '2026-11-07');
      expect(accepted.startTime, '14:00');
      expect(accepted.proposedDate, isNull);
      expect(accepted.rescheduleReason, isNull);

      final declined = proposed.declineReschedule();
      expect(declined.status, 'scheduled');
      expect(declined.date, '2026-11-05');
      expect(declined.proposedDate, isNull);
      expect(declined.previousDate, isNull);

      final completed = initial.markCompleted();
      expect(completed.isCompleted, isTrue);
      expect(completed.canReschedule, isFalse);
    });

    test('BookingModel monthly lifecycle getters', () {
      final sessions = [
        const BookingSessionModel(id: 's1', date: '2026-11-01', startTime: '10:00', endTime: '11:00', status: 'completed'),
        const BookingSessionModel(id: 's2', date: '2026-11-03', startTime: '10:00', endTime: '11:00', status: 'completed'),
        const BookingSessionModel(id: 's3', date: '2026-11-06', startTime: '10:00', endTime: '11:00', status: 'reschedule_pending'),
        const BookingSessionModel(id: 's4', date: '2026-11-09', startTime: '10:00', endTime: '11:00', status: 'scheduled'),
      ];

      final booking = BookingModel(
        id: 'b_monthly',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Gym',
        bookingType: 'monthly',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
        sessions: sessions,
      );

      expect(booking.getSessionById('s3')?.status, 'reschedule_pending');
      expect(booking.getSessionById('non_existent'), isNull);
      expect(booking.hasPendingSessionReschedule, isTrue);
      expect(booking.pendingRescheduleSessions.length, 1);
      expect(booking.pendingRescheduleSessions.first.id, 's3');
      expect(booking.completedSessionsCount, 2);
      expect(booking.progressRatio, 0.5); // 2 of 4 = 50%

      // Next upcoming session should be s3 (earliest upcoming non-completed)
      expect(booking.nextUpcomingSession?.id, 's3');
    });



    test('BookingModel direct monthly methods update parent and sessions', () {
      final sessions = [
        const BookingSessionModel(id: 's1', date: '2026-11-01', startTime: '10:00', endTime: '11:00'),
        const BookingSessionModel(id: 's2', date: '2026-11-03', startTime: '10:00', endTime: '11:00'),
      ];

      final initial = BookingModel(
        id: 'b1',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Tennis',
        bookingType: 'monthly',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
        status: 'confirmed',
        sessions: sessions,
      );

      final withProposal = initial.proposeMonthlySessionReschedule(
        sessionId: 's1',
        proposedDate: '2026-11-05',
        proposedStartTime: '11:00',
        proposedEndTime: '12:00',
        reason: 'Coach seminar',
        rescheduledBy: 'coach',
      );
      expect(withProposal.status, 'reschedule_pending');
      expect(withProposal.sessions.first.isReschedulePending, isTrue);

      final accepted = withProposal.acceptMonthlySessionReschedule(sessionId: 's1');
      expect(accepted.status, 'confirmed');
      expect(accepted.sessions.first.date, '2026-11-05');

      final declined = withProposal.declineMonthlySessionReschedule(sessionId: 's1');
      expect(declined.status, 'confirmed');
      expect(declined.sessions.first.date, '2026-11-01');

      final s1Done = accepted.completeMonthlySession(sessionId: 's1');
      expect(s1Done.status, 'confirmed');
      final s2Done = s1Done.completeMonthlySession(sessionId: 's2');
      expect(s2Done.status, 'completed');
    });
  });
}
