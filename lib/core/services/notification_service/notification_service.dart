import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../database_service/firestore_service.dart';
import '../logger_service/logger_service.dart';
import 'fcm_token_manager.dart';
import 'local_notification_bridge.dart';
import 'notification_background_handler.dart';
import 'notification_deep_link_handler.dart';
import 'pending_deep_link_queue.dart';

class NotificationService {
  static const String channelId = LocalNotificationBridge.channelId;

  final FirebaseMessaging? _injectedMessaging;
  final LocalNotificationBridge _localBridge;
  final FcmTokenManager _tokenManager;
  final PendingDeepLinkQueue _deepLinkQueue;

  String _languageCode = 'en';
  bool _notificationsEnabled = true;

  NotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    required FirestoreService firestoreService,
    FcmTokenManager? tokenManager,
    LocalNotificationDisplayer? displayOverride,
    DeepLinkDispatcher? deepLinkDispatcher,
  }) : _injectedMessaging = messaging,
       _localBridge = LocalNotificationBridge(
         plugin: localNotifications,
         displayOverride: displayOverride,
       ),
       _tokenManager =
           tokenManager ?? FcmTokenManager(firestoreService: firestoreService),
       _deepLinkQueue = PendingDeepLinkQueue(
         dispatcher:
             deepLinkDispatcher ?? NotificationDeepLinkHandler.handlePayload,
       );

  String get languageCode => _languageCode;
  bool get notificationsEnabled => _notificationsEnabled;
  Map<String, dynamic>? get pendingInitialPayload =>
      _deepLinkQueue.pendingPayload;
  bool get isRouterReady => _deepLinkQueue.isRouterReady;
  bool hasDelivered(String? id) => _localBridge.deduplicator.hasDelivered(id);
  FirebaseMessaging get _messaging =>
      _injectedMessaging ?? FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await _localBridge.initialize(
        onNotificationTap: _deepLinkQueue.routeOrQueueRawJson,
      );
      await _captureLaunchPayload();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(
        (msg) => _deepLinkQueue.routeOrQueue(msg.data),
      );
    } catch (e, st) {
      LoggerService.error('FCM init failed: $e', error: e, stackTrace: st);
    }
  }

  Future<void> _captureLaunchPayload() async {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _deepLinkQueue.queue(initial.data);
      return;
    }
    final rawLaunch = await _localBridge.getLaunchPayload();
    if (rawLaunch != null && rawLaunch.isNotEmpty) {
      _deepLinkQueue.queueRawJson(rawLaunch);
    }
  }

  void queuePendingDeepLink(Map<String, dynamic> payload) =>
      _deepLinkQueue.queue(payload);

  Future<void> consumePendingDeepLink() => _deepLinkQueue.consume();
  void clearPendingDeepLink() => _deepLinkQueue.clear();

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    if (!_notificationsEnabled) return;
    await _localBridge.showForegroundRemoteMessage(message);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    String? notificationId,
  }) async {
    if (!_notificationsEnabled) return;
    await _localBridge.show(
      id: id,
      title: title,
      body: body,
      payload: payload,
      notificationId: notificationId,
    );
  }

  void updatePreferences({String? languageCode, bool? notificationsEnabled}) {
    if (languageCode != null && languageCode.isNotEmpty)
      _languageCode = languageCode;
    if (notificationsEnabled != null)
      _notificationsEnabled = notificationsEnabled;
  }

  Future<void> syncFcmToken(
    String uid, {
    String? role,
    String? languageCode,
    bool? notificationsEnabled,
  }) {
    updatePreferences(
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
    );
    return _tokenManager.syncToken(
      uid: uid,
      languageCode: _languageCode,
      notificationsEnabled: _notificationsEnabled,
      role: role,
    );
  }

  Future<void> syncUserPreferences({
    required String uid,
    String? languageCode,
    bool? notificationsEnabled,
    String? role,
  }) {
    updatePreferences(
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
    );
    return _tokenManager.syncUserPreferences(
      uid: uid,
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
      role: role,
    );
  }

  Future<void> detachFcmToken(String uid) => _tokenManager.detachToken(uid);
  Future<void> deleteFcmTokenDoc(String uid) =>
      _tokenManager.deleteTokenDoc(uid);
}
