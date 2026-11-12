import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/notifications/data/helpers/notification_dispatcher.dart';
import 'package:fitness_app/features/notifications/data/models/notification_model.dart';
import 'package:fitness_app/features/notifications/data/models/notification_type.dart';
import 'package:fitness_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationsRepo implements NotificationsRepository {
  final List<NotificationModel> sent = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<Failure, String>> sendNotification(
    NotificationModel notification,
  ) async {
    sent.add(notification);
    return Right(notification.id.isNotEmpty ? notification.id : 'generated_id');
  }
}

void main() {
  group('Notification Event Trigger Matrix (Milestone 9.2)', () {
    late FakeNotificationsRepo fakeRepo;
    late NotificationDispatcher dispatcher;

    const sampleBooking = BookingModel(
      id: 'b_100',
      coachUid: 'coach_1',
      coachName: 'Coach Mike',
      traineeUid: 'trainee_1',
      traineeName: 'Jane Doe',
      sport: 'Tennis',
      bookingType: 'monthly',
      date: '2026-11-15',
      startTime: '10:00',
      endTime: '11:00',
      price: 150.0,
    );

    setUp(() {
      fakeRepo = FakeNotificationsRepo();
      dispatcher = NotificationDispatcher(repository: fakeRepo);
    });

    test('New Booking Request sends alerts to both Coach and Admin', () async {
      await dispatcher.dispatchNewBooking(
        booking: sampleBooking,
        traineeName: 'Jane Doe',
      );

      expect(fakeRepo.sent.length, 2);
      final coachNotif = fakeRepo.sent[0];
      final adminNotif = fakeRepo.sent[1];

      expect(coachNotif.recipientRole, 'coach');
      expect(coachNotif.type, NotificationType.bookingNew);
      expect(adminNotif.recipientRole, 'admin');
      expect(adminNotif.recipientUid, 'admin');
    });

    test('Booking Approved & Rejected notify Trainee', () async {
      await dispatcher.dispatchBookingApproved(
        booking: sampleBooking,
        coachName: 'Coach Mike',
      );
      await dispatcher.dispatchBookingRejected(
        booking: sampleBooking,
        coachName: 'Coach Mike',
        reason: 'Fully booked',
      );

      expect(fakeRepo.sent.length, 2);
      expect(fakeRepo.sent[0].type, NotificationType.bookingApproved);
      expect(fakeRepo.sent[0].recipientUid, 'trainee_1');
      expect(fakeRepo.sent[1].type, NotificationType.bookingRejected);
      expect(fakeRepo.sent[1].data['reason'], 'Fully booked');
    });

    test(
      'Reschedule Proposed, Accepted & Declined notify counter-party',
      () async {
        await dispatcher.dispatchSingleRescheduleProposed(
          booking: sampleBooking,
          senderUid: 'coach_1',
          senderName: 'Coach Mike',
          recipientUid: 'trainee_1',
          recipientRole: 'trainee',
          proposedDate: '2026-11-20',
          proposedTime: '15:00',
          reason: 'Schedule conflict',
        );
        await dispatcher.dispatchSingleRescheduleAccepted(
          booking: sampleBooking,
          senderUid: 'trainee_1',
          senderName: 'Jane Doe',
          recipientUid: 'coach_1',
          recipientRole: 'coach',
          date: '2026-11-20',
        );

        expect(
          fakeRepo.sent[0].type,
          NotificationType.bookingRescheduleProposed,
        );
        expect(
          fakeRepo.sent[1].type,
          NotificationType.bookingRescheduleAccepted,
        );
      },
    );

    test(
      'Monthly session completed alerts trainee with progress details',
      () async {
        await dispatcher.dispatchMonthlySessionCompleted(
          booking: sampleBooking,
          sessionNumber: 3,
          sessionId: 's3',
          completedCount: 3,
          totalCount: 8,
        );

        final notif = fakeRepo.sent.first;
        expect(notif.type, NotificationType.bookingMonthlySessionCompleted);
        expect(notif.recipientUid, 'trainee_1');
        expect(notif.bodyEn, contains('3/8 done'));
      },
    );

    test(
      'Mobile-originated admin alerts queue verification and cancellation events',
      () async {
        await dispatcher.dispatchCoachVerificationSubmitted(
          coachUid: 'coach_9',
          coachName: 'Alex',
        );
        await dispatcher.dispatchBookingCancelled(
          booking: sampleBooking,
          traineeName: 'Jane Doe',
        );

        expect(fakeRepo.sent.length, 3);
        expect(
          fakeRepo.sent[0].type,
          NotificationType.coachVerificationSubmitted,
        );
        expect(fakeRepo.sent[0].recipientRole, 'admin');
        expect(fakeRepo.sent[1].type, NotificationType.bookingCancelled);
        expect(fakeRepo.sent[1].recipientRole, 'coach');
        expect(fakeRepo.sent[2].type, NotificationType.bookingCancelled);
        expect(fakeRepo.sent[2].recipientRole, 'admin');
      },
    );
  });
}
