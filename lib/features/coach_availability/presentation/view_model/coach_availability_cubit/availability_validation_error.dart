import 'package:fitness_app/core/models/day_availability.dart';

enum AvailabilityErrorType {
  none,
  noActiveDays,
  invalidTimeRange,
  windowTooShort,
}

class AvailabilityValidationError {
  final AvailabilityErrorType type;
  final DayOfWeek? day;
  final int? requiredDurationMinutes;

  const AvailabilityValidationError({
    required this.type,
    this.day,
    this.requiredDurationMinutes,
  });

  /// At least one working day, and every working day ends after it starts
  /// with room for one session. Null when the schedule is fine.
  static AvailabilityValidationError? check(
    List<DayAvailability> schedule,
    int durationMinutes,
  ) {
    final activeDays = schedule.where((d) => d.isAvailable).toList();
    if (activeDays.isEmpty) {
      return const AvailabilityValidationError(
        type: AvailabilityErrorType.noActiveDays,
      );
    }
    for (final day in activeDays) {
      final startMin = day.fromTime.hour * 60 + day.fromTime.minute;
      final endMin = day.toTime.hour * 60 + day.toTime.minute;
      if (endMin <= startMin) {
        return AvailabilityValidationError(
          type: AvailabilityErrorType.invalidTimeRange,
          day: day.day,
        );
      }
      if ((endMin - startMin) < durationMinutes) {
        return AvailabilityValidationError(
          type: AvailabilityErrorType.windowTooShort,
          day: day.day,
          requiredDurationMinutes: durationMinutes,
        );
      }
    }
    return null;
  }
}
