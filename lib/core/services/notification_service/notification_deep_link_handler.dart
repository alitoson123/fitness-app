import 'package:dartz/dartz.dart';
import '../../../features/booking_details/data/repos/booking_details_repo.dart';
import '../../../features/booking_details/presentation/view_model/booking_details_args.dart';
import '../../../features/booking_request/data/models/booking_model.dart';
import '../../../features/notifications/data/models/notification_type.dart';
import '../../errors/failure.dart';
import '../../locator_service/service_locator.dart';
import '../../navigator/app_router.dart';
import '../../navigator/app_routes.dart';
import '../../services/auth_service/auth_service.dart';
import '../../services/logger_service/logger_service.dart';

typedef BookingFetcher =
    Future<Either<Failure, BookingModel>> Function(String bookingId);

class NotificationDeepLinkHandler {
  static bool _busy = false;

  /// [onBookingLoadFailed]: when given (taps inside the inbox), a booking
  /// that can't be loaded shows this message instead of leaving the screen.
  static Future<void> handlePayload(
    Map<String, dynamic> data, {
    void Function(String message)? onBookingLoadFailed,
  }) async {
    // A second tap while the booking is still loading would open it twice.
    if (_busy) return;
    _busy = true;
    try {
      await handlePayloadWith(
        data: data,
        currentUid: getIt<AuthService>().currentUser?.uid,
        fetchBooking: getIt<BookingDetailsRepo>().getBooking,
        pushRoute: (route, {extra}) =>
            AppRouter.router.push(route, extra: extra),
        goRoute: (route) => AppRouter.router.go(route),
        currentLocation: () =>
            AppRouter.router.routeInformationProvider.value.uri.path,
        onBookingLoadFailed: onBookingLoadFailed,
      );
    } finally {
      _busy = false;
    }
  }

  static Future<void> handlePayloadWith({
    required Map<String, dynamic> data,
    required String? currentUid,
    required BookingFetcher fetchBooking,
    required void Function(String route, {Object? extra}) pushRoute,
    required void Function(String route) goRoute,
    String Function()? currentLocation,
    void Function(String message)? onBookingLoadFailed,
  }) async {
    try {
      if (currentUid == null || currentUid.isEmpty) {
        LoggerService.info(
          'Ignoring notification deep link while signed out',
          tag: 'NotificationDeepLinkHandler',
        );
        return;
      }

      final bookingId = data['bookingId']?.toString();
      final type = data['type']?.toString() ?? '';

      LoggerService.info(
        'Handling notification tap payload: $data',
        tag: 'NotificationDeepLinkHandler',
      );

      if (bookingId != null && bookingId.isNotEmpty) {
        final result = await fetchBooking(bookingId);
        result.fold(
          (failure) {
            LoggerService.warning(
              'Could not load booking for deep link: ${failure.errorMessage}',
              tag: 'NotificationDeepLinkHandler',
            );
            if (onBookingLoadFailed != null) {
              onBookingLoadFailed(failure.errorMessage);
            } else {
              _fallbackRoute(data, goRoute);
            }
          },
          (booking) {
            final isCoach = currentUid == booking.coachUid;
            pushRoute(
              AppRoutes.bookingDetails,
              extra: BookingDetailsArgs(booking: booking, isCoach: isCoach),
            );
          },
        );
        return;
      }

      if (type == NotificationType.coachVerificationSubmitted ||
          type == NotificationType.coachProfileRejected) {
        if (currentLocation?.call() != AppRoutes.coachVerificationPending) {
          pushRoute(AppRoutes.coachVerificationPending);
        }
        return;
      }

      if (type == NotificationType.coachProfileApproved) {
        goRoute(AppRoutes.coachDashboard);
        return;
      }

      if (type == NotificationType.adminWarning ||
          type == NotificationType.accountSuspended) {
        if (currentLocation?.call() != AppRoutes.notifications) {
          pushRoute(AppRoutes.notifications);
        }
        return;
      }

      _fallbackRoute(data, goRoute);
    } catch (e, st) {
      LoggerService.error(
        'Deep link dispatch failed: $e',
        tag: 'NotificationDeepLinkHandler',
        error: e,
        stackTrace: st,
      );
    }
  }

  static void _fallbackRoute(
    Map<String, dynamic> data,
    void Function(String route) goRoute,
  ) {
    final role = data['recipientRole']?.toString();
    if (role == 'coach') {
      goRoute(AppRoutes.coachDashboard);
    } else {
      goRoute(AppRoutes.traineeHome);
    }
  }
}
