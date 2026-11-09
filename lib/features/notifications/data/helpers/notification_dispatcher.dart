import '../../../booking_request/data/models/booking_model.dart';
import '../repos/notifications_repo.dart';
import 'admin_notification_dispatcher.dart';
import 'booking_notification_dispatcher.dart';
import 'reschedule_notification_dispatcher.dart';

class NotificationDispatcher {
  final BookingNotificationDispatcher bookingDispatcher;
  final RescheduleNotificationDispatcher rescheduleDispatcher;
  final AdminNotificationDispatcher adminDispatcher;

  NotificationDispatcher({required NotificationsRepository repository})
      : bookingDispatcher =
            BookingNotificationDispatcher(repository: repository),
        rescheduleDispatcher =
            RescheduleNotificationDispatcher(repository: repository),
        adminDispatcher = AdminNotificationDispatcher(repository: repository);

  // 1. Booking Creation & Status
  Future<void> dispatchNewBooking({
    required BookingModel booking,
    required String traineeName,
  }) => bookingDispatcher.dispatchNewBooking(
        booking: booking,
        traineeName: traineeName,
      );

  Future<void> dispatchBookingApproved({
    required BookingModel booking,
    required String coachName,
  }) => bookingDispatcher.dispatchBookingApproved(
        booking: booking,
        coachName: coachName,
      );

  Future<void> dispatchBookingRejected({
    required BookingModel booking,
    required String coachName,
    required String reason,
  }) => bookingDispatcher.dispatchBookingRejected(
        booking: booking,
        coachName: coachName,
        reason: reason,
      );

  Future<void> dispatchBookingCancelled({
    required BookingModel booking,
    required String traineeName,
  }) => bookingDispatcher.dispatchBookingCancelled(
        booking: booking,
        traineeName: traineeName,
      );

  // 2. Rescheduling
  Future<void> dispatchSingleRescheduleProposed({
    required BookingModel booking,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
    required String proposedDate,
    required String proposedTime,
    required String reason,
  }) => rescheduleDispatcher.dispatchSingleRescheduleProposed(
        booking: booking,
        senderUid: senderUid,
        senderName: senderName,
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        proposedDate: proposedDate,
        proposedTime: proposedTime,
        reason: reason,
      );

  Future<void> dispatchSingleRescheduleAccepted({
    required BookingModel booking,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
    required String date,
  }) => rescheduleDispatcher.dispatchSingleRescheduleAccepted(
        booking: booking,
        senderUid: senderUid,
        senderName: senderName,
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        date: date,
      );

  Future<void> dispatchSingleRescheduleDeclined({
    required BookingModel booking,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
  }) => rescheduleDispatcher.dispatchSingleRescheduleDeclined(
        booking: booking,
        senderUid: senderUid,
        senderName: senderName,
        recipientUid: recipientUid,
        recipientRole: recipientRole,
      );

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
  }) => rescheduleDispatcher.dispatchMonthlyRescheduleProposed(
        booking: booking,
        sessionNumber: sessionNumber,
        sessionId: sessionId,
        senderUid: senderUid,
        senderName: senderName,
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        proposedDate: proposedDate,
        proposedTime: proposedTime,
      );

  Future<void> dispatchMonthlyRescheduleAccepted({
    required BookingModel booking,
    required int sessionNumber,
    required String sessionId,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
  }) => rescheduleDispatcher.dispatchMonthlyRescheduleAccepted(
        booking: booking,
        sessionNumber: sessionNumber,
        sessionId: sessionId,
        senderUid: senderUid,
        senderName: senderName,
        recipientUid: recipientUid,
        recipientRole: recipientRole,
      );

  Future<void> dispatchMonthlyRescheduleDeclined({
    required BookingModel booking,
    required int sessionNumber,
    required String sessionId,
    required String senderUid,
    required String senderName,
    required String recipientUid,
    required String recipientRole,
  }) => rescheduleDispatcher.dispatchMonthlyRescheduleDeclined(
        booking: booking,
        sessionNumber: sessionNumber,
        sessionId: sessionId,
        senderUid: senderUid,
        senderName: senderName,
        recipientUid: recipientUid,
        recipientRole: recipientRole,
      );

  Future<void> dispatchMonthlySessionCompleted({
    required BookingModel booking,
    required int sessionNumber,
    required String sessionId,
    required int completedCount,
    required int totalCount,
  }) => rescheduleDispatcher.dispatchMonthlySessionCompleted(
        booking: booking,
        sessionNumber: sessionNumber,
        sessionId: sessionId,
        completedCount: completedCount,
        totalCount: totalCount,
      );

  // 3. Admin & Verification
  Future<void> dispatchCoachVerificationSubmitted({
    required String coachUid,
    required String coachName,
  }) => adminDispatcher.dispatchCoachVerificationSubmitted(
        coachUid: coachUid,
        coachName: coachName,
      );

  Future<void> dispatchCoachProfileApproved({required String coachUid}) =>
      adminDispatcher.dispatchCoachProfileApproved(coachUid: coachUid);

  Future<void> dispatchCoachProfileRejected({
    required String coachUid,
    required String reason,
  }) => adminDispatcher.dispatchCoachProfileRejected(
        coachUid: coachUid,
        reason: reason,
      );

  Future<void> dispatchAdminWarning({
    required String recipientUid,
    required String recipientRole,
    required String warningTitle,
    required String warningDetails,
  }) => adminDispatcher.dispatchAdminWarning(
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        warningTitle: warningTitle,
        warningDetails: warningDetails,
      );

  Future<void> dispatchAccountSuspended({
    required String recipientUid,
    required String recipientRole,
    String? reason,
  }) => adminDispatcher.dispatchAccountSuspended(
        recipientUid: recipientUid,
        recipientRole: recipientRole,
        reason: reason,
      );
}
