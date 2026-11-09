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
  }) => (
    titleEn: 'New Booking Request',
    titleAr: 'طلب حجز جديد',
    bodyEn: 'New booking request from $traineeName for $sport ($bookingType)',
    bodyAr: 'طلب حجز جديد من $traineeName لرياضة $sport ($bookingType)',
  );

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
    bodyEn: 'Coach $coachName declined your request. Reason: $reason',
    bodyAr: 'اعتذر المدرب $coachName عن قبول طلبك. السبب: $reason',
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
