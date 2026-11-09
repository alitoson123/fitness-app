import '../../../../core/constant/app_constants.dart';
import '../models/notification_model.dart';
import '../models/notification_type.dart';
import '../repos/notifications_repo.dart';
import 'admin_notification_templates.dart';

class AdminNotificationDispatcher {
  final NotificationsRepository repository;

  AdminNotificationDispatcher({required this.repository});

  Future<void> dispatchCoachVerificationSubmitted({
    required String coachUid,
    required String coachName,
  }) async {
    final text = AdminNotificationTemplates.coachVerificationSubmitted(
      coachName: coachName,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: AppConstants.roleAdmin,
        recipientRole: AppConstants.roleAdmin,
        senderUid: coachUid,
        senderName: coachName,
        type: NotificationType.coachVerificationSubmitted,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'coachUid': coachUid, 'coachName': coachName},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchCoachProfileApproved({
    required String coachUid,
  }) async {
    final text = AdminNotificationTemplates.coachProfileApproved();
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: coachUid,
        recipientRole: AppConstants.roleCoach,
        senderUid: AppConstants.roleAdmin,
        senderName: 'CoachHub Admin',
        type: NotificationType.coachProfileApproved,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'status': 'approved'},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchCoachProfileRejected({
    required String coachUid,
    required String reason,
  }) async {
    final text =
        AdminNotificationTemplates.coachProfileRejected(reason: reason);
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: coachUid,
        recipientRole: AppConstants.roleCoach,
        senderUid: AppConstants.roleAdmin,
        senderName: 'CoachHub Admin',
        type: NotificationType.coachProfileRejected,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'status': 'rejected', 'reason': reason},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchAdminWarning({
    required String recipientUid,
    required String recipientRole,
    required String warningTitle,
    required String warningDetails,
  }) async {
    final text = AdminNotificationTemplates.adminWarning(
      title: warningTitle,
      details: warningDetails,
    );
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: AppConstants.roleAdmin,
        senderName: 'CoachHub Admin',
        type: NotificationType.adminWarning,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'title': warningTitle, 'details': warningDetails},
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> dispatchAccountSuspended({
    required String recipientUid,
    required String recipientRole,
    String? reason,
  }) async {
    final text = AdminNotificationTemplates.accountSuspended(reason: reason);
    await repository.sendNotification(
      NotificationModel(
        id: '',
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        senderUid: AppConstants.roleAdmin,
        senderName: 'CoachHub Admin',
        type: NotificationType.accountSuspended,
        titleEn: text.titleEn,
        titleAr: text.titleAr,
        bodyEn: text.bodyEn,
        bodyAr: text.bodyAr,
        data: {'status': 'suspended', 'reason': ?reason},
        createdAt: DateTime.now(),
      ),
    );
  }
}

