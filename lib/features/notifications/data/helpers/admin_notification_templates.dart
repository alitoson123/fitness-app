import 'booking_notification_templates.dart';

/// Pre-localized bilingual templates for mobile-originated Admin Dashboard alerts.
abstract class AdminNotificationTemplates {
  static NotificationText coachVerificationSubmitted({
    required String coachName,
  }) => (
    titleEn: 'Coach Verification Submitted',
    titleAr: 'تقديم طلب توثيق مدرب',
    bodyEn: 'Coach $coachName submitted verification documents for approval',
    bodyAr: 'قدم المدرب $coachName مستندات التحقق للموافقة',
  );
}
