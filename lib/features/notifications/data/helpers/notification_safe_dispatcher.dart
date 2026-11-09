import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import 'notification_dispatcher.dart';

abstract class NotificationSafeDispatcher {
  static void dispatch(
    Future<void> Function(NotificationDispatcher dispatcher) action,
  ) {
    if (getIt.isRegistered<NotificationDispatcher>()) {
      try {
        action(getIt<NotificationDispatcher>()).catchError((e) {
          LoggerService.warning(
            'Asynchronous notification dispatch error: $e',
            tag: 'NotificationSafeDispatcher',
          );
        });
      } catch (e) {
        LoggerService.warning(
          'Synchronous notification dispatch error: $e',
          tag: 'NotificationSafeDispatcher',
        );
      }
    }
  }
}
