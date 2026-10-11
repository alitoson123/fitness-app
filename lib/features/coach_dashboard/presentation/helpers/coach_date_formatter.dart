import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

abstract class CoachDateFormatter {
  static DateTime? parseDateTime(String dateStr, [String? timeStr]) {
    final parsedDate = DateTime.tryParse(dateStr);
    if (parsedDate == null) return null;
    if (timeStr == null || timeStr.isEmpty) return parsedDate;

    final parts = timeStr.trim().split(RegExp(r'[:\s]'));
    if (parts.isEmpty) return parsedDate;

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

    final upper = timeStr.toUpperCase();
    if (upper.contains('PM') && hour < 12) hour += 12;
    if (upper.contains('AM') && hour == 12) hour = 0;

    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      hour,
      minute,
    );
  }

  static String formatHumanDate(BuildContext context, String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diffDays = target.difference(today).inDays;

    final s = S.of(context);
    if (diffDays == 0) return s.groupToday;
    if (diffDays == 1) return s.groupTomorrow;

    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('EEE, MMM d', locale).format(date);
  }

  static String formatCountdown(BuildContext context, BookingModel booking) {
    final s = S.of(context);
    final sessionDt = parseDateTime(booking.date, booking.startTime);
    if (sessionDt == null) return booking.date;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(
      sessionDt.year,
      sessionDt.month,
      sessionDt.day,
    );
    final diffDays = sessionDay.difference(today).inDays;

    if (diffDays == 0) {
      final diff = sessionDt.difference(now);
      if (diff.isNegative) return s.sessionPassed;
      if (diff.inHours > 0) {
        return s.countdownHoursMins(diff.inHours, diff.inMinutes % 60);
      }
      if (diff.inMinutes > 0) {
        return s.countdownMins(diff.inMinutes);
      }
      return s.countdownToday(booking.startTime);
    }
    if (diffDays == 1) {
      return s.countdownTomorrow(booking.startTime);
    }
    if (diffDays > 1 && diffDays <= 7) {
      return s.sessionCountdownDays(diffDays);
    }
    return formatHumanDate(context, booking.date);
  }
}
