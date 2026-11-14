import '../../../../core/constant/app_constants.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../models/notification_model.dart';
import '../models/notification_type.dart';
import '../repos/notifications_repo.dart';
import 'booking_notification_templates.dart';

class BookingNotificationDispatcher {
  final NotificationsRepository repository;

  BookingNotificationDispatcher({required this.repository});

  Future<void> dispatchNewBooking({
    required BookingModel booking,
    required String traineeName,
  }) async {
    final text = BookingNotificationTemplates.newBooking(
      traineeName: traineeName,
      sport: booking.sport,
      bookingType: booking.bookingType,
    );
    final payload = {
      'bookingId': booking.id,
      'priceUSD': booking.priceUSD,
      'date': booking.date,
      'bookingType': booking.bookingType,
    };
    final now = DateTime.now();

    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: booking.coachUid,
        recipientRole: AppConstants.roleCoach,
        senderUid: booking.traineeUid,
        senderName: traineeName,
        type: NotificationType.bookingNew,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: payload,
        createdAt: now,
      ),
    );

    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: AppConstants.roleAdmin,
        recipientRole: AppConstants.roleAdmin,
        senderUid: booking.traineeUid,
        senderName: traineeName,
        type: NotificationType.bookingNew,
        titleEn: '${text.titleEn} (Admin Alert)',
        titleAr: '${text.titleAr} (تنبيه إدارة)',
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: payload,
        createdAt: now,
      ),
    );
  }

  Future<void> dispatchBookingApproved({
    required BookingModel booking,
    required String coachName,
  }) async {
    final text = BookingNotificationTemplates.bookingApproved(
      coachName: coachName,
      date: booking.date,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: booking.traineeUid,
        recipientRole: AppConstants.roleTrainee,
        senderUid: booking.coachUid,
        senderName: coachName,
        type: NotificationType.bookingApproved,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'bookingId': booking.id, 'date': booking.date},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchBookingRejected({
    required BookingModel booking,
    required String coachName,
    required String reason,
  }) async {
    final text = BookingNotificationTemplates.bookingRejected(
      coachName: coachName,
      reason: reason,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: booking.traineeUid,
        recipientRole: AppConstants.roleTrainee,
        senderUid: booking.coachUid,
        senderName: coachName,
        type: NotificationType.bookingRejected,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'bookingId': booking.id, 'reason': reason, 'date': booking.date},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchBookingCompleted({
    required BookingModel booking,
    required String coachName,
  }) async {
    final text = BookingNotificationTemplates.bookingCompleted(
      coachName: coachName,
      date: booking.date,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: booking.traineeUid,
        recipientRole: AppConstants.roleTrainee,
        senderUid: booking.coachUid,
        senderName: coachName,
        type: NotificationType.bookingCompleted,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'bookingId': booking.id, 'date': booking.date},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchBookingCancelled({
    required BookingModel booking,
    required String traineeName,
  }) async {
    final text = BookingNotificationTemplates.bookingCancelled(
      traineeName: traineeName,
      date: booking.date,
    );
    final payload = {'bookingId': booking.id, 'date': booking.date};
    final now = DateTime.now();

    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: booking.coachUid,
        recipientRole: AppConstants.roleCoach,
        senderUid: booking.traineeUid,
        senderName: traineeName,
        type: NotificationType.bookingCancelled,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: payload,
        createdAt: now,
      ),
    );

    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: AppConstants.roleAdmin,
        recipientRole: AppConstants.roleAdmin,
        senderUid: booking.traineeUid,
        senderName: traineeName,
        type: NotificationType.bookingCancelled,
        titleEn: '${text.titleEn} (Admin Alert)',
        titleAr: '${text.titleAr} (تنبيه إدارة)',
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: payload,
        createdAt: now,
      ),
    );
  }
}
