import '../../../../core/constant/app_constants.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../models/notification_model.dart';
import '../models/notification_type.dart';
import '../repos/notifications_repo.dart';
import 'booking_notification_templates.dart';

class RescheduleNotificationDispatcher {
  final NotificationsRepository repository;

  RescheduleNotificationDispatcher({required this.repository});

  Future<void> dispatchSingleRescheduleProposed({
    required BookingModel booking,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
    required String proposedDate,
    required String proposedTime,
    required String reason,
  }) async {
    final text = BookingNotificationTemplates.singleRescheduleProposed(
      senderName: senderName,
      date: proposedDate,
      time: proposedTime,
      reason: reason,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: senderUid,
        senderName: senderName,
        type: NotificationType.bookingRescheduleProposed,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {
          'bookingId': booking.id,
          'date': proposedDate,
          'time': proposedTime,
          'reason': reason,
        },
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchSingleRescheduleAccepted({
    required BookingModel booking,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
    required String date,
  }) async {
    final text = BookingNotificationTemplates.singleRescheduleAccepted(
      responderName: senderName,
      date: date,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: senderUid,
        senderName: senderName,
        type: NotificationType.bookingRescheduleAccepted,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'bookingId': booking.id, 'date': date},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchSingleRescheduleDeclined({
    required BookingModel booking,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
  }) async {
    final text = BookingNotificationTemplates.singleRescheduleDeclined(
      responderName: senderName,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: senderUid,
        senderName: senderName,
        type: NotificationType.bookingRescheduleDeclined,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'bookingId': booking.id},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchMonthlyRescheduleProposed({
    required BookingModel booking,
    required int sessionNumber,
    required String sessionId,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
    required String proposedDate,
    required String proposedTime,
  }) async {
    final text = BookingNotificationTemplates.monthlyRescheduleProposed(
      senderName: senderName,
      sessionNumber: sessionNumber,
      date: proposedDate,
      time: proposedTime,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: senderUid,
        senderName: senderName,
        type: NotificationType.bookingMonthlySessionRescheduleProposed,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {
          'bookingId': booking.id,
          'sessionId': sessionId,
          'sessionNumber': sessionNumber,
          'date': proposedDate,
          'time': proposedTime,
        },
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchMonthlyRescheduleAccepted({
    required BookingModel booking,
    required int sessionNumber,
    required String sessionId,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
  }) async {
    final text = BookingNotificationTemplates.monthlyRescheduleAccepted(
      responderName: senderName,
      sessionNumber: sessionNumber,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: senderUid,
        senderName: senderName,
        type: NotificationType.bookingMonthlySessionRescheduleAccepted,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {
          'bookingId': booking.id,
          'sessionId': sessionId,
          'sessionNumber': sessionNumber,
        },
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchMonthlyRescheduleDeclined({
    required BookingModel booking,
    required int sessionNumber,
    required String sessionId,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
  }) async {
    final text = BookingNotificationTemplates.monthlyRescheduleDeclined(
      responderName: senderName,
      sessionNumber: sessionNumber,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: senderUid,
        senderName: senderName,
        type: NotificationType.bookingMonthlySessionRescheduleDeclined,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {
          'bookingId': booking.id,
          'sessionId': sessionId,
          'sessionNumber': sessionNumber,
        },
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchMonthlySessionCompleted({
    required BookingModel booking,
    required int sessionNumber,
    required String sessionId,
    required int completedCount,
    required int totalCount,
  }) async {
    final text = BookingNotificationTemplates.monthlySessionCompleted(
      sessionNumber: sessionNumber,
      completed: completedCount,
      total: totalCount,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: booking.traineeUid,
        recipientRole: AppConstants.roleTrainee,
        senderUid: booking.coachUid,
        senderName: booking.coachName,
        type: NotificationType.bookingMonthlySessionCompleted,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {
          'bookingId': booking.id,
          'sessionId': sessionId,
          'sessionNumber': sessionNumber,
          'completedCount': completedCount,
          'totalCount': totalCount,
        },
        createdAt: DateTime.now(),
      ),
    );
  }
}
