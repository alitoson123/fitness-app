import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TrainingPeriod { day, month, year }

abstract class TrainingInsightsCalculator {
  static Set<DateTime> extractUniqueCompletedDays(List<BookingModel> bookings) {
    final days = <DateTime>{};

    for (final booking in bookings) {
      final isBookingCompleted =
          booking.status.trim().toLowerCase() == 'completed';

      if (booking.sessions.isNotEmpty) {
        var anySessionCompleted = false;
        for (final session in booking.sessions) {
          if (session.status.trim().toLowerCase() == 'completed') {
            anySessionCompleted = true;
            _recordDate(days, session.date, booking);
          }
        }
        if (isBookingCompleted && !anySessionCompleted) {
          for (final session in booking.sessions) {
            _recordDate(days, session.date, booking);
          }
        }
      } else if (isBookingCompleted) {
        _recordDate(days, booking.date, booking);
      }
    }
    return days;
  }

  static void _recordDate(
    Set<DateTime> days,
    String dateStr,
    BookingModel booking,
  ) {
    final parsed =
        _parseDate(dateStr) ?? booking.updatedAt ?? booking.createdAt;
    if (parsed != null) {
      days.add(DateTime(parsed.year, parsed.month, parsed.day));
    }
  }

  static DateTime? _parseDate(String dateStr) {
    if (dateStr.trim().isEmpty) return null;
    return DateTime.tryParse(dateStr.trim());
  }

  static int calculateUniqueDays({
    required Set<DateTime> completedDays,
    required TrainingPeriod period,
    required DateTime referenceDate,
  }) {
    switch (period) {
      case TrainingPeriod.day:
        return completedDays.any(
              (d) =>
                  d.year == referenceDate.year &&
                  d.month == referenceDate.month &&
                  d.day == referenceDate.day,
            )
            ? 1
            : 0;
      case TrainingPeriod.month:
        return completedDays
            .where(
              (d) =>
                  d.year == referenceDate.year &&
                  d.month == referenceDate.month,
            )
            .length;
      case TrainingPeriod.year:
        return completedDays.where((d) => d.year == referenceDate.year).length;
    }
  }

  static String formatPeriodTitle(
    BuildContext context,
    TrainingPeriod period,
    DateTime date,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();

    switch (period) {
      case TrainingPeriod.day:
        final isToday =
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
        final formattedDate = DateFormat('d MMM yyyy', locale).format(date);
        return isToday
            ? '${S.of(context).groupToday} • $formattedDate'
            : DateFormat('EEEE, d MMM yyyy', locale).format(date);
      case TrainingPeriod.month:
        return DateFormat('MMMM yyyy', locale).format(date);
      case TrainingPeriod.year:
        return DateFormat('yyyy', locale).format(date);
    }
  }
}
