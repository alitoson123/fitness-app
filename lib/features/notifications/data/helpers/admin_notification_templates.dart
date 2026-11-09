import 'booking_notification_templates.dart';

/// Pre-localized bilingual templates for admin, verification, and moderation events.
abstract class AdminNotificationTemplates {
  static NotificationText coachVerificationSubmitted({
    required String coachName,
  }) => (
    titleEn: 'Coach Verification Submitted',
    titleAr: 'تقديم طلب توثيق مدرب',
    bodyEn: 'Coach $coachName submitted verification documents for approval',
    bodyAr: 'قدم المدرب $coachName مستندات التحقق للموافقة',
  );

  static NotificationText coachProfileApproved() => (
    titleEn: 'Profile Approved!',
    titleAr: 'تمت الموافقة على ملفك الشخصي!',
    bodyEn:
        'Congratulations! Your coach profile has been approved by the Admin',
    bodyAr: 'تهانينا! تمت الموافقة على ملفك الشخصي كمدرب من قبل الإدارة',
  );

  static NotificationText coachProfileRejected({required String reason}) => (
    titleEn: 'Verification Rejected',
    titleAr: 'تم رفض التوثيق',
    bodyEn: 'Your verification was rejected. Reason: $reason',
    bodyAr: 'تم رفض طلب التحقق الخاص بك. السبب: $reason',
  );

  static NotificationText adminWarning({
    required String title,
    required String details,
  }) => (titleEn: title, titleAr: title, bodyEn: details, bodyAr: details);

  static NotificationText accountSuspended({String? reason}) => (
    titleEn: 'Account Suspended',
    titleAr: 'تم تعليق الحساب',
    bodyEn: reason != null && reason.trim().isNotEmpty
        ? 'Your account has been suspended: $reason'
        : 'Your account has been suspended by the administrator',
    bodyAr: reason != null && reason.trim().isNotEmpty
        ? 'تم تعليق حسابك: $reason'
        : 'تم تعليق حسابك من قبل إدارة التطبيق',
  );
}
