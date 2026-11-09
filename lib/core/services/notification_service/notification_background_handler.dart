import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../logger_service/logger_service.dart';

/// Top-level background message handler required by Firebase Messaging.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LoggerService.info(
    'Handling background FCM message: ${message.messageId}',
    tag: 'NotificationService',
  );
}
