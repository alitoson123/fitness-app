import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'coach_date_formatter.dart';

abstract class CoachBookingGrouper {
  static BookingModel? getNearestUpcomingSession(
    List<BookingModel> confirmedBookings,
  ) {
    if (confirmedBookings.isEmpty) return null;
    final now = DateTime.now();

    final valid = confirmedBookings.map((b) {
      final dt = CoachDateFormatter.parseDateTime(b.date, b.startTime);
      return (booking: b, dt: dt);
    }).where((item) {
      if (item.dt == null) return false;
      return item.dt!.isAfter(now.subtract(const Duration(hours: 1)));
    }).toList();

    if (valid.isEmpty) return null;
    valid.sort((a, b) => a.dt!.compareTo(b.dt!));
    return valid.first.booking;
  }

  static double calculateMonthEarnings(List<BookingModel> bookings) {
    final now = DateTime.now();
    double total = 0.0;
    for (final b in bookings) {
      if (b.status != 'confirmed' && b.status != 'completed') continue;
      final dt = DateTime.tryParse(b.date);
      if (dt != null && dt.year == now.year && dt.month == now.month) {
        total += b.price;
      }
    }
    return total;
  }

  static List<({DateTime date, int count, bool isToday})> getWeekDays(
    List<BookingModel> bookings,
  ) {
    final now = DateTime.now();
    final currentDayOfWeek = now.weekday; // 1 = Mon, 7 = Sun
    final monday = now.subtract(Duration(days: currentDayOfWeek - 1));

    return List.generate(7, (index) {
      final day = DateTime(monday.year, monday.month, monday.day + index);
      final isToday = day.year == now.year &&
          day.month == now.month &&
          day.day == now.day;

      final count = bookings.where((b) {
        if (b.status != 'confirmed' && b.status != 'pending') return false;
        final bDate = DateTime.tryParse(b.date);
        return bDate != null &&
            bDate.year == day.year &&
            bDate.month == day.month &&
            bDate.day == day.day;
      }).length;

      return (date: day, count: count, isToday: isToday);
    });
  }

  static Map<String, List<BookingModel>> groupBookings(
    BuildContext context,
    List<BookingModel> bookings, {
    required bool isPastTab,
  }) {
    final s = S.of(context);
    final map = <String, List<BookingModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isPastTab) {
      map[s.groupPast] = bookings;
      return map;
    }

    for (final b in bookings) {
      final bDate = DateTime.tryParse(b.date);
      if (bDate == null) {
        map.putIfAbsent(s.groupLater, () => []).add(b);
        continue;
      }
      final target = DateTime(bDate.year, bDate.month, bDate.day);
      final diff = target.difference(today).inDays;

      if (diff == 0) {
        map.putIfAbsent(s.groupToday, () => []).add(b);
      } else if (diff == 1) {
        map.putIfAbsent(s.groupTomorrow, () => []).add(b);
      } else if (diff > 1 && diff <= 7) {
        map.putIfAbsent(s.groupThisWeek, () => []).add(b);
      } else {
        map.putIfAbsent(s.groupLater, () => []).add(b);
      }
    }
    return map;
  }
}
