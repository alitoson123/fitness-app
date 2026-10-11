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
}
