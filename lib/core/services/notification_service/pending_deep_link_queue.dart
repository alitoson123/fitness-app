import 'dart:convert';
import '../logger_service/logger_service.dart';

typedef DeepLinkDispatcher = Future<void> Function(Map<String, dynamic> data);

/// Coordinates cold-start and pre-navigation notification deep-link payloads
/// until the router completes splash authentication resolution.
class PendingDeepLinkQueue {
  final DeepLinkDispatcher _dispatcher;
  Map<String, dynamic>? _pendingPayload;
  bool _isRouterReady = false;

  PendingDeepLinkQueue({required DeepLinkDispatcher dispatcher})
      : _dispatcher = dispatcher;

  Map<String, dynamic>? get pendingPayload => _pendingPayload;
  bool get isRouterReady => _isRouterReady;

  void queue(Map<String, dynamic> payload) {
    _pendingPayload = Map<String, dynamic>.from(payload);
  }

  void queueRawJson(String rawPayload) {
    try {
      final decoded = jsonDecode(rawPayload) as Map<String, dynamic>;
      queue(decoded);
    } catch (e) {
      LoggerService.error(
        'Error parsing launch notification payload: $e',
        tag: 'PendingDeepLinkQueue',
      );
    }
  }

  void routeOrQueue(Map<String, dynamic> payload) {
    if (!_isRouterReady) {
      queue(payload);
      return;
    }
    _dispatcher(payload);
  }

  void routeOrQueueRawJson(String? rawPayload) {
    if (rawPayload == null || rawPayload.isEmpty) return;
    try {
      routeOrQueue(jsonDecode(rawPayload) as Map<String, dynamic>);
    } catch (e) {
      LoggerService.error(
        'Error parsing notification tap payload: $e',
        tag: 'PendingDeepLinkQueue',
      );
    }
  }

  Future<void> consume() async {
    _isRouterReady = true;
    final payload = _pendingPayload;
    _pendingPayload = null;
    if (payload != null) {
      await _dispatcher(payload);
    }
  }

  void clear() {
    _isRouterReady = true;
    _pendingPayload = null;
  }
}

