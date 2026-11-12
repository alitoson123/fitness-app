import 'dart:collection';

/// Bounded deduplication tracker and deterministic ID generator
/// ensuring foreground FCM messages and Firestore stream updates
/// never render duplicate local heads-up banners.
class NotificationDeduplicator {
  final int maxEntries;
  final ListQueue<String> _order = ListQueue<String>();
  final Set<String> _deliveredIds = <String>{};

  NotificationDeduplicator({this.maxEntries = 200});

  bool hasDelivered(String? notificationId) {
    if (notificationId == null || notificationId.isEmpty) return false;
    return _deliveredIds.contains(notificationId);
  }

  /// Marks [notificationId] as delivered and returns true if it was not
  /// previously recorded. Returns false when already delivered.
  bool markDeliveredIfNew(String? notificationId) {
    if (notificationId == null || notificationId.isEmpty) return true;
    if (_deliveredIds.contains(notificationId)) return false;
    _record(notificationId);
    return true;
  }

  void markDelivered(String? notificationId) {
    if (notificationId == null || notificationId.isEmpty) return;
    if (_deliveredIds.contains(notificationId)) return;
    _record(notificationId);
  }

  void _record(String notificationId) {
    _deliveredIds.add(notificationId);
    _order.addLast(notificationId);
    while (_order.length > maxEntries) {
      final evicted = _order.removeFirst();
      _deliveredIds.remove(evicted);
    }
  }

  void clear() {
    _order.clear();
    _deliveredIds.clear();
  }

  /// Deterministic positive 31-bit integer ID safe for Android & iOS APIs.
  static int stableNotificationId(String key) {
    var hash = 5381;
    for (final unit in key.codeUnits) {
      hash = (((hash << 5) + hash) + unit) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }
}
