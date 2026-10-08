import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../models/day_availability.dart';

class AvailabilityHelper {
  static String getDayShortName(BuildContext context, DayOfWeek day) {
    final s = S.of(context);
    switch (day) {
      case DayOfWeek.monday:
        return s.dayMon;
      case DayOfWeek.tuesday:
        return s.dayTue;
      case DayOfWeek.wednesday:
        return s.dayWed;
      case DayOfWeek.thursday:
        return s.dayThu;
      case DayOfWeek.friday:
        return s.dayFri;
      case DayOfWeek.saturday:
        return s.daySat;
      case DayOfWeek.sunday:
        return s.daySun;
    }
  }

  static String getDayFullName(BuildContext context, DayOfWeek day) {
    final s = S.of(context);
    switch (day) {
      case DayOfWeek.monday:
        return s.dayMonday;
      case DayOfWeek.tuesday:
        return s.dayTuesday;
      case DayOfWeek.wednesday:
        return s.dayWednesday;
      case DayOfWeek.thursday:
        return s.dayThursday;
      case DayOfWeek.friday:
        return s.dayFriday;
      case DayOfWeek.saturday:
        return s.daySaturday;
      case DayOfWeek.sunday:
        return s.daySunday;
    }
  }

  static String formatTime(BuildContext context, TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final formattedHour = hour.toString().padLeft(2, '0');
    return '$formattedHour:$minute $period';
  }

  static String formatSummary(
    BuildContext context,
    List<DayAvailability> schedule,
  ) {
    final availableDays = schedule.where((d) => d.isAvailable).toList();
    if (availableDays.isEmpty) {
      return S.of(context).noDaysSelected;
    }

    final dayNames = availableDays
        .map((d) => getDayShortName(context, d.day))
        .join(', ');

    final first = availableDays.first;
    final fromStr = formatTime(context, first.fromTime);
    final toStr = formatTime(context, first.toTime);

    return '$dayNames ($fromStr - $toStr)';
  }
}
