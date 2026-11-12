import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../logger_service/logger_service.dart';
import 'notification_deduplicator.dart';

typedef LocalNotificationDisplayer =
    Future<void> Function({
      required int id,
      required String title,
      required String body,
      String? tag,
      String? payload,
    });

/// Wrapper around [FlutterLocalNotificationsPlugin] for channel setup,
/// launch payload inspection, and deduplicated foreground heads-up banners.
class LocalNotificationBridge {
  static const String channelId = 'coachhub_high_importance';
  static const String channelName = 'CoachHub Alerts';
  static const String channelDescription = 'High priority alerts.';

  final FlutterLocalNotificationsPlugin? _injectedPlugin;
  final LocalNotificationDisplayer? _displayOverride;
  final NotificationDeduplicator deduplicator;

  LocalNotificationBridge({
    FlutterLocalNotificationsPlugin? plugin,
    LocalNotificationDisplayer? displayOverride,
    NotificationDeduplicator? deduplicator,
  }) : _injectedPlugin = plugin,
       _displayOverride = displayOverride,
       deduplicator = deduplicator ?? NotificationDeduplicator();

  FlutterLocalNotificationsPlugin get _plugin =>
      _injectedPlugin ?? FlutterLocalNotificationsPlugin();

  /// Initializes local notification settings, registers the tap handler,
  /// and creates the high-importance Android channel.
  Future<void> initialize({
    required void Function(String? rawPayload) onNotificationTap,
  }) async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (r) => onNotificationTap(r.payload),
    );
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(channel);
  }

  /// Returns the notification payload if a local alert launched the app.
  Future<String?> getLaunchPayload() async {
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp ?? false) {
        return details?.notificationResponse?.payload;
      }
    } catch (e) {
      LoggerService.warning(
        'Failed reading launch notification details: $e',
        tag: 'LocalNotificationBridge',
      );
    }
    return null;
  }

  /// Displays a deduplicated heads-up banner for a foreground FCM message.
  Future<void> showForegroundRemoteMessage(RemoteMessage message) async {
    final notificationId = message.data['notificationId']?.toString();
    if (!deduplicator.markDeliveredIfNew(notificationId)) return;

    final notif = message.notification;
    await show(
      id: notificationId != null && notificationId.isNotEmpty
          ? NotificationDeduplicator.stableNotificationId(notificationId)
          : message.hashCode,
      notificationId: notificationId,
      title: notif?.title ?? message.data['title']?.toString() ?? 'CoachHub',
      body: notif?.body ?? message.data['body']?.toString() ?? '',
      payload: message.data,
    );
  }

  /// Shows a heads-up notification with a stable ID and records delivery.
  Future<void> show({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    String? notificationId,
  }) async {
    final effectiveId = notificationId != null && notificationId.isNotEmpty
        ? NotificationDeduplicator.stableNotificationId(notificationId)
        : id;
    deduplicator.markDelivered(notificationId);
    final encoded = payload != null ? jsonEncode(payload) : null;

    if (_displayOverride != null) {
      await _displayOverride(
        id: effectiveId,
        title: title,
        body: body,
        tag: notificationId,
        payload: encoded,
      );
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      tag: notificationId,
    );
    await _plugin.show(
      id: effectiveId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      ),
      payload: encoded,
    );
  }
}
