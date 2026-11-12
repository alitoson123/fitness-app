import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../database_service/firestore_service.dart';
import '../logger_service/logger_service.dart';
import 'fcm_token_storage_helper.dart';

/// Manages multi-device FCM token registration, refresh listeners,
/// sign-out detachment, and account deletion cleanup.
class FcmTokenManager {
  final FcmTokenStorageHelper _storage;
  final Future<String?> Function()? _tokenProvider;
  final Stream<String>? _tokenRefreshStream;
  final String Function()? _platformProvider;

  StreamSubscription<String>? _refreshSubscription;
  String? _activeUid;
  String? _lastSyncedToken;

  FcmTokenManager({
    required FirestoreService firestoreService,
    Future<String?> Function()? tokenProvider,
    Stream<String>? tokenRefreshStream,
    String Function()? platformProvider,
  }) : _storage = FcmTokenStorageHelper(firestoreService: firestoreService),
       _tokenProvider = tokenProvider,
       _tokenRefreshStream = tokenRefreshStream,
       _platformProvider = platformProvider;

  /// Returns a deterministic 16-char hex hash safe for Firestore map keys.
  static String hashToken(String token) =>
      FcmTokenStorageHelper.hashToken(token);

  /// Syncs the device FCM token and user preferences, and listens for refresh.
  Future<void> syncToken({
    required String uid,
    required String languageCode,
    required bool notificationsEnabled,
    String? role,
  }) async {
    if (uid.isEmpty) return;
    _activeUid = uid;
    try {
      final token = await _resolveToken();
      if (token != null && token.isNotEmpty) {
        _lastSyncedToken = token;
        await _storage.saveToken(
          uid: uid,
          token: token,
          platform: _platformProvider?.call() ?? Platform.operatingSystem,
          languageCode: languageCode,
          notificationsEnabled: notificationsEnabled,
          role: role,
        );
      }
      await _refreshSubscription?.cancel();
      final stream =
          _tokenRefreshStream ?? FirebaseMessaging.instance.onTokenRefresh;
      _refreshSubscription = stream.listen((newToken) {
        if (_activeUid == uid && newToken.isNotEmpty) {
          _lastSyncedToken = newToken;
          _storage.saveToken(
            uid: uid,
            token: newToken,
            platform: _platformProvider?.call() ?? Platform.operatingSystem,
            languageCode: languageCode,
            notificationsEnabled: notificationsEnabled,
            role: role,
          );
        }
      });
    } catch (e, st) {
      LoggerService.error(
        'Error syncing FCM token: $e',
        tag: 'FcmTokenManager',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Updates language, notification mute toggle, or role in Firestore.
  Future<void> syncUserPreferences({
    required String uid,
    String? languageCode,
    bool? notificationsEnabled,
    String? role,
  }) async {
    if (uid.isEmpty) return;
    try {
      await _storage.updatePreferences(
        uid: uid,
        languageCode: languageCode,
        notificationsEnabled: notificationsEnabled,
        role: role,
      );
    } catch (e) {
      LoggerService.warning(
        'Failed syncing FCM preferences for $uid: $e',
        tag: 'FcmTokenManager',
      );
    }
  }

  /// Detaches only the current device token on sign-out and stops refresh.
  Future<void> detachToken(String uid) async {
    await _cancelSubscription(uid);
    if (uid.isEmpty) return;
    try {
      final token = _lastSyncedToken ?? await _resolveToken();
      _lastSyncedToken = null;
      if (token == null || token.isEmpty) return;
      await _storage.removeToken(uid: uid, token: token);
    } catch (e) {
      LoggerService.warning('Failed detaching FCM token for $uid: $e');
    }
  }

  /// Deletes the user's entire `fcm_tokens/{uid}` document on account deletion.
  Future<void> deleteTokenDoc(String uid) async {
    await _cancelSubscription(uid);
    _lastSyncedToken = null;
    if (uid.isEmpty) return;
    try {
      await _storage.deleteDoc(uid);
    } catch (e) {
      LoggerService.warning('Failed deleting FCM token doc for $uid: $e');
    }
  }

  /// Cancels the active token refresh stream and clears the active UID.
  Future<void> _cancelSubscription(String uid) async {
    await _refreshSubscription?.cancel();
    _refreshSubscription = null;
    if (_activeUid == uid) _activeUid = null;
  }

  /// Fetches the FCM token using the injected provider or FirebaseMessaging.
  Future<String?> _resolveToken() async =>
      _tokenProvider != null
          ? _tokenProvider()
          : FirebaseMessaging.instance.getToken();
}
