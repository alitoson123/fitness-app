/// Matrix of standard notification types across all roles.
abstract class NotificationType {
  static const String bookingNew = 'booking_new';
  static const String bookingApproved = 'booking_approved';
  static const String bookingRejected = 'booking_rejected';
  static const String bookingRescheduleProposed = 'booking_reschedule_proposed';
  static const String bookingRescheduleAccepted = 'booking_reschedule_accepted';
  static const String bookingRescheduleDeclined = 'booking_reschedule_declined';
  static const String bookingMonthlySessionRescheduleProposed =
      'booking_monthly_session_reschedule_proposed';
  static const String bookingMonthlySessionRescheduleAccepted =
      'booking_monthly_session_reschedule_accepted';
  static const String bookingMonthlySessionRescheduleDeclined =
      'booking_monthly_session_reschedule_declined';
  static const String bookingMonthlySessionCompleted =
      'booking_monthly_session_completed';
  static const String bookingCancelled = 'booking_cancelled';

  static const String coachVerificationSubmitted =
      'coach_verification_submitted';
  static const String coachProfileApproved = 'coach_profile_approved';
  static const String coachProfileRejected = 'coach_profile_rejected';
  static const String adminWarning = 'admin_warning';
  static const String accountSuspended = 'account_suspended';

  static bool isBookingRelated(String type) {
    return type.startsWith('booking_');
  }

  static bool isAdminRelated(String type) {
    return type == adminWarning ||
        type == accountSuspended ||
        type == coachVerificationSubmitted ||
        type == coachProfileApproved ||
        type == coachProfileRejected;
  }
}
