import '../../../../core/constant/app_constants.dart';
import '../models/notification_model.dart';
import '../models/notification_type.dart';
import '../repos/notifications_repo.dart';
import 'admin_notification_templates.dart';

/// Dispatches mobile-originated alert events to the `admin_notifications` queue
/// consumed by the Admin Web Dashboard via Firestore real-time stream.
///
/// Admin-to-user moderation notifications (`coach_profile_approved`,
/// `coach_profile_rejected`, `admin_warning`, `account_suspended`) are
/// dispatched directly from the Admin Web Dashboard (`fitness_app_dashboard`)
/// into `notifications/{id}`.
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
}
