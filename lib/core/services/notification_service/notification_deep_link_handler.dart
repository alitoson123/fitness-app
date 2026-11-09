import '../../locator_service/service_locator.dart';
import '../../navigator/app_router.dart';
import '../../navigator/app_routes.dart';
import '../../services/auth_service/auth_service.dart';
import '../../services/logger_service/logger_service.dart';
import '../../../features/booking_details/data/repos/booking_details_repo.dart';
import '../../../features/booking_details/presentation/view_model/booking_details_args.dart';
import '../../../features/notifications/data/models/notification_type.dart';

class NotificationDeepLinkHandler {
  static Future<void> handlePayload(Map<String, dynamic> data) async {
    try {
      final bookingId = data['bookingId'] as String?;
      final type = data['type'] as String? ?? '';
      final currentUid = getIt<AuthService>().currentUser?.uid;

      LoggerService.info(
        'Handling notification tap payload: $data',
        tag: 'NotificationDeepLinkHandler',
      );

      if (bookingId != null && bookingId.isNotEmpty) {
        final result = await getIt<BookingDetailsRepo>().getBooking(bookingId);
        result.fold(
          (failure) {
            LoggerService.warning(
              'Could not load booking for deep link: ${failure.errorMessage}',
              tag: 'NotificationDeepLinkHandler',
            );
            _fallbackRoute(data);
          },
          (booking) {
            final isCoach = currentUid == booking.coachUid;
            AppRouter.router.push(
              AppRoutes.bookingDetails,
              extra: BookingDetailsArgs(booking: booking, isCoach: isCoach),
            );
          },
        );
        return;
      }

      if (type == NotificationType.coachVerificationSubmitted ||
          type == NotificationType.coachProfileRejected) {
        AppRouter.router.push(AppRoutes.coachVerificationPending);
        return;
      }

      if (type == NotificationType.coachProfileApproved) {
        AppRouter.router.go(AppRoutes.coachDashboard);
        return;
      }

      _fallbackRoute(data);
    } catch (e, st) {
      LoggerService.error(
        'Deep link dispatch failed: $e',
        tag: 'NotificationDeepLinkHandler',
        error: e,
        stackTrace: st,
      );
    }
  }

  static void _fallbackRoute(Map<String, dynamic> data) {
    final role = data['recipientRole'] as String?;
    if (role == 'coach') {
      AppRouter.router.go(AppRoutes.coachDashboard);
    } else {
      AppRouter.router.go(AppRoutes.traineeHome);
    }
  }
}
