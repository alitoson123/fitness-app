typedef NotificationText = ({
  String titleEn,
  String titleAr,
  String bodyEn,
  String bodyAr,
});

/// Pre-localized bilingual templates for booking and reschedule events.
abstract class BookingNotificationTemplates {
  static NotificationText newBooking({
    required String traineeName,
    required String sport,
    required String bookingType,
  }) {
    final sportName = NotificationDisplayNames.sport(sport);
    final kind = NotificationDisplayNames.bookingType(bookingType);
    return (
      titleEn: 'New Booking Request',
      titleAr: 'طلب حجز جديد',
      bodyEn:
          'New booking request from $traineeName for ${sportName.en} (${kind.en})',
      bodyAr:
          'طلب حجز جديد من $traineeName لرياضة ${sportName.ar} (${kind.ar})',
    );
  }

  static NotificationText bookingApproved({
    required String coachName,
    required String date,
  }) => (
    titleEn: 'Booking Approved',
    titleAr: 'تمت الموافقة على الحجز',
    bodyEn: 'Coach $coachName approved your booking request for $date',
    bodyAr: 'وافق المدرب $coachName على طلب الحجز الخاص بك لتاريخ $date',
  );

  static NotificationText bookingRejected({
    required String coachName,
    required String reason,
  }) => (
    titleEn: 'Booking Declined',
    titleAr: 'تم رفض الحجز',
    bodyEn:
        'Coach $coachName declined your request. Reason: ${reason.isEmpty ? 'No reason given' : reason}',
    bodyAr:
        'اعتذر المدرب $coachName عن قبول طلبك. السبب: ${reason.isEmpty ? 'لم يُذكر سبب' : reason}',
  );

  static NotificationText bookingCompleted({
    required String coachName,
    required String date,
  }) => (
    titleEn: 'Session Completed',
    titleAr: 'اكتملت الجلسة',
    bodyEn: 'Coach $coachName marked your session on $date as completed',
    bodyAr: 'حدد المدرب $coachName جلستك بتاريخ $date كمكتملة',
  );

  static NotificationText singleRescheduleProposed({
    required String senderName,
    required String date,
    required String time,
    required String reason,
  }) => (
    titleEn: 'Reschedule Proposed',
    titleAr: 'اقتراح موعد جديد',
    bodyEn: '$senderName proposed a new time: $date at $time. Reason: $reason',
    bodyAr:
        'اقترح $senderName موعداً جديداً: $date الساعة $time. السبب: $reason',
  );

  static NotificationText singleRescheduleAccepted({
    required String responderName,
    required String date,
  }) => (
    titleEn: 'Reschedule Accepted',
    titleAr: 'تم قبول الموعد الجديد',
    bodyEn: '$responderName accepted the proposed reschedule for $date',
    bodyAr: 'وافق $responderName على الموعد المقترح لتاريخ $date',
  );

  static NotificationText singleRescheduleDeclined({
    required String responderName,
  }) => (
    titleEn: 'Reschedule Declined',
    titleAr: 'تم رفض الموعد المقترح',
    bodyEn: '$responderName declined the proposed reschedule',
    bodyAr: 'رفض $responderName الموعد المقترح',
  );

  static NotificationText monthlyRescheduleProposed({
    required String senderName,
    required int sessionNumber,
    required String date,
    required String time,
  }) => (
    titleEn: 'Monthly Session Reschedule',
    titleAr: 'إعادة جدولة جلسة شهرية',
    bodyEn:
        '$senderName proposed rescheduling Session #$sessionNumber of your monthly plan to $date at $time',
    bodyAr:
        'اقترح $senderName إعادة جدولة الجلسة رقم $sessionNumber لخطتك الشهرية إلى $date الساعة $time',
  );

  static NotificationText monthlyRescheduleAccepted({
    required String responderName,
    required int sessionNumber,
  }) => (
    titleEn: 'Session Reschedule Accepted',
    titleAr: 'تم قبول إعادة جدولة الجلسة',
    bodyEn: '$responderName accepted the new time for Session #$sessionNumber',
    bodyAr: 'وافق $responderName على الموعد الجديد للجلسة رقم $sessionNumber',
  );

  static NotificationText monthlyRescheduleDeclined({
    required String responderName,
    required int sessionNumber,
  }) => (
    titleEn: 'Session Reschedule Declined',
    titleAr: 'تم رفض إعادة جدولة الجلسة',
    bodyEn:
        '$responderName declined the reschedule for Session #$sessionNumber',
    bodyAr: 'رفض $responderName إعادة جدولة الجلسة رقم $sessionNumber',
  );

  static NotificationText monthlySessionCompleted({
    required int sessionNumber,
    required int completed,
    required int total,
  }) => (
    titleEn: 'Session Completed',
    titleAr: 'اكتملت الجلسة',
    bodyEn:
        'Session #$sessionNumber was marked as completed. Progress: $completed/$total done!',
    bodyAr:
        'تم تحديد الجلسة رقم $sessionNumber كمكتملة. التقدم: $completed/$total مكتملة!',
  );

  static NotificationText bookingCancelled({
    required String traineeName,
    required String date,
  }) => (
    titleEn: 'Booking Cancelled',
    titleAr: 'تم إلغاء الحجز',
    bodyEn: '$traineeName cancelled the booking for $date',
    bodyAr: 'ألغى $traineeName الحجز لتاريخ $date',
  );
}

/// English/Arabic names for notification text, which is stored in both
/// languages at once (so `S.of(context)` can't be used). Same values as the
/// sport* / singleSessionType / monthlyPackageType keys in lib/l10n (a test
/// checks this) and functions/src/utils/display_names.ts.
abstract class NotificationDisplayNames {
  static const Map<String, ({String en, String ar})> _sports = {
    'football': (en: 'Football', ar: 'كرة القدم'),
    'basketball': (en: 'Basketball', ar: 'كرة السلة'),
    'swimming': (en: 'Swimming', ar: 'السباحة'),
    'tennis': (en: 'Tennis', ar: 'التنس'),
    'running': (en: 'Running', ar: 'الجري'),
    'boxing': (en: 'Boxing', ar: 'الملاكمة'),
    'gym': (en: 'Gym', ar: 'جيم وكمال أجسام'),
    'cycling': (en: 'Cycling', ar: 'ركوب الدراجات'),
    'martial_arts': (en: 'Martial Arts', ar: 'فنون قتالية'),
    'volleyball': (en: 'Volleyball', ar: 'كرة الطائرة'),
    'padel': (en: 'Padel', ar: 'بادل'),
    'badminton': (en: 'Badminton', ar: 'كرة الريشة'),
    'table_tennis': (en: 'Table Tennis', ar: 'كرة الطاولة'),
    'crossfit': (en: 'CrossFit', ar: 'كروس فيت'),
    'handball': (en: 'Handball', ar: 'كرة اليد'),
  };

  /// Known sports are translated; a custom sport keeps the coach's text.
  static ({String en, String ar}) sport(String raw) {
    final key = raw.trim().toLowerCase().replaceAll(' ', '_');
    return _sports[key] ?? (en: raw.trim(), ar: raw.trim());
  }

  static ({String en, String ar}) bookingType(String raw) => raw == 'monthly'
      ? (en: 'Monthly Plan', ar: 'باقة شهرية')
      : (en: 'Single Session', ar: 'جلسة فردية');

  /// For the drift test.
  static Iterable<String> get sportKeys => _sports.keys;
}
