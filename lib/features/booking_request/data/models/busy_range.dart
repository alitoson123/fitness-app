/// A period on one day when the coach is already taken, in minutes since
/// midnight (`end` is exclusive, so back-to-back sessions don't clash).
class BusyRange {
  final int start;
  final int end;

  const BusyRange(this.start, this.end);

  bool overlaps(int otherStart, int otherEnd) =>
      otherStart < end && start < otherEnd;

  /// `HH:mm` -> minutes, or null. `24:00` is allowed as an end time.
  static int? minutesOf(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 24 || m < 0 || m > 59) {
      return null;
    }
    return h * 60 + m;
  }

  /// Parses `HH:mm-HH:mm` (as written by the `onBookingWritten` function).
  static BusyRange? parse(String value) {
    final parts = value.split('-');
    if (parts.length != 2) return null;
    final start = minutesOf(parts[0]);
    final end = minutesOf(parts[1]);
    if (start == null || end == null || end <= start) return null;
    return BusyRange(start, end);
  }

  /// A start time only (older busy-slot documents): assume one session.
  static BusyRange? fromStart(String startTime, int durationMinutes) {
    final start = minutesOf(startTime);
    if (start == null) return null;
    return BusyRange(
      start,
      start + (durationMinutes > 0 ? durationMinutes : 60),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is BusyRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'BusyRange($start-$end)';
}
