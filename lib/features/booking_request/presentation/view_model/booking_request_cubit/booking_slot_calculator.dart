import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

class BookingSlotCalculator {
  static DayOfWeek getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.saturday:
        return DayOfWeek.saturday;
      case DateTime.sunday:
        return DayOfWeek.sunday;
      case DateTime.monday:
        return DayOfWeek.monday;
      case DateTime.tuesday:
        return DayOfWeek.tuesday;
      case DateTime.wednesday:
        return DayOfWeek.wednesday;
      case DateTime.thursday:
        return DayOfWeek.thursday;
      case DateTime.friday:
        return DayOfWeek.friday;
      default:
        return DayOfWeek.monday;
    }
  }

  static bool isCoachWorkingOnDay(CoachProfileModel coach, DateTime date) {
    final dayOfWeek = getDayOfWeek(date);
    if (coach.weeklyAvailability.isNotEmpty) {
      for (final a in coach.weeklyAvailability) {
        if (a.day == dayOfWeek) return a.isAvailable;
      }
    }
    if (coach.workingDays.isNotEmpty) {
      return coach.workingDays.any(
        (d) => d.toLowerCase() == dayOfWeek.name.toLowerCase(),
      );
    }
    return true;
  }

  static List<String> generateDaySlots({
    required CoachProfileModel coach,
    required DateTime date,
    required List<String> bookedSlots,
  }) {
    final dayOfWeek = getDayOfWeek(date);
    int fromHour = 17;
    int fromMinute = 0;
    int toHour = 21;
    int toMinute = 0;

    if (coach.weeklyAvailability.isNotEmpty) {
      for (final a in coach.weeklyAvailability) {
        if (a.day == dayOfWeek) {
          if (!a.isAvailable) return [];
          fromHour = a.fromTime.hour;
          fromMinute = a.fromTime.minute;
          toHour = a.toTime.hour;
          toMinute = a.toTime.minute;
          break;
        }
      }
    }

    final durationMin = coach.sessionDurationMinutes > 0
        ? coach.sessionDurationMinutes
        : 60;
    int currentMinutes = fromHour * 60 + fromMinute;
    final endMinutes = toHour * 60 + toMinute;

    final slots = <String>[];
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final currentDayMinutes = now.hour * 60 + now.minute;

    while (currentMinutes + durationMin <= endMinutes) {
      final slotStartHour = currentMinutes ~/ 60;
      final slotStartMin = currentMinutes % 60;
      final slotStr =
          '${slotStartHour.toString().padLeft(2, '0')}:${slotStartMin.toString().padLeft(2, '0')}';

      // Check if not booked and if today, is in future
      final isSlotInPast =
          isToday && (currentMinutes <= currentDayMinutes + 15);
      if (!bookedSlots.contains(slotStr) && !isSlotInPast) {
        slots.add(slotStr);
      }
      currentMinutes += durationMin;
    }

    return slots;
  }

  static String computeEndTime(String startTime, int durationMin) {
    final parts = startTime.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final total = h * 60 + m + (durationMin > 0 ? durationMin : 60);
    final endH = (total ~/ 60) % 24;
    final endM = total % 60;
    return '${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}';
  }
}
