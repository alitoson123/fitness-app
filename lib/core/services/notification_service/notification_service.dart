import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../constant/app_constants.dart';
import '../database_service/firestore_service.dart';
import '../logger_service/logger_service.dart';
import 'notification_background_handler.dart';
import 'notification_deep_link_handler.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FirestoreService _firestoreService;

  static const String channelId = 'coachhub_high_importance';
  static const String channelName = 'CoachHub Alerts';
  static const String channelDescription = 'High priority alerts.';

  NotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    required FirestoreService firestoreService,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications = localNotifications ?? FlutterLocalNotificationsPlugin(),
       _firestoreService = firestoreService;

  Future<void> initialize() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);

      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
        macOS: DarwinInitializationSettings(),
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          if (response.payload != null) {
            try {
              final data = jsonDecode(response.payload!) as Map<String, dynamic>;
              NotificationDeepLinkHandler.handlePayload(data);
            } catch (e) {
              LoggerService.error('Error parsing tap payload: $e');
            }
          }
        },
      );

      const androidChannel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(androidChannel);

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_showForegroundNotification);
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        NotificationDeepLinkHandler.handlePayload(message.data);
      });
      _checkInitialMessage();
    } catch (e, st) {
      LoggerService.error('FCM init failed: $e', error: e, stackTrace: st);
    }
  }

  Future<void> _checkInitialMessage() async {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      NotificationDeepLinkHandler.handlePayload(initial.data);
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] ?? 'CoachHub';
    final body = notification?.body ?? message.data['body'] ?? '';
    await showNotification(
      id: message.hashCode,
      title: title,
      body: body,
      payload: message.data,
    );
  }

  Future<void> syncFcmToken(String uid) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) await _saveTokenToFirestore(uid, token);
      _messaging.onTokenRefresh.listen((t) => _saveTokenToFirestore(uid, t));
    } catch (e, st) {
      LoggerService.error('Error syncing FCM token: $e', error: e, stackTrace: st);
    }
  }

  Future<void> _saveTokenToFirestore(String uid, String token) async {
    await _firestoreService.setData(
      collection: AppConstants.fcmTokensCollection,
      docId: uid,
      data: {
        'token': token,
        'uid': uid,
        'platform': Platform.operatingSystem,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }
}
