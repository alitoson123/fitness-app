import 'package:fitness_app/core/models/day_availability.dart';
import 'availability_validation_error.dart';

abstract class CoachAvailabilityState {
  const CoachAvailabilityState();
}

class CoachAvailabilityInitial extends CoachAvailabilityState {
  const CoachAvailabilityInitial();
}

class CoachAvailabilityLoading extends CoachAvailabilityState {
  const CoachAvailabilityLoading();
}

class CoachAvailabilityLoaded extends CoachAvailabilityState {
  final List<DayAvailability> schedule;
  final int sessionDurationMinutes;
  final DayOfWeek selectedDay;
  final bool isSaving;
  final String? errorMessage;
  final AvailabilityValidationError? validationError;
  final bool saveSuccess;
  final String? infoMessage;

  const CoachAvailabilityLoaded({
    required this.schedule,
    this.sessionDurationMinutes = 60,
    this.selectedDay = DayOfWeek.sunday,
    this.isSaving = false,
    this.errorMessage,
    this.validationError,
    this.saveSuccess = false,
    this.infoMessage,
  });

  DayAvailability get currentDayAvailability => schedule.firstWhere(
    (item) => item.day == selectedDay,
    orElse: () => DayAvailability(day: selectedDay),
  );

  int get activeDaysCount => schedule.where((d) => d.isAvailable).length;

  CoachAvailabilityLoaded copyWith({
    List<DayAvailability>? schedule,
    int? sessionDurationMinutes,
    DayOfWeek? selectedDay,
    bool? isSaving,
    String? errorMessage,
    AvailabilityValidationError? validationError,
    bool? saveSuccess,
    String? infoMessage,
    bool clearError = false,
    bool clearInfo = false,
  }) {
    return CoachAvailabilityLoaded(
      schedule: schedule ?? this.schedule,
      sessionDurationMinutes:
          sessionDurationMinutes ?? this.sessionDurationMinutes,
      selectedDay: selectedDay ?? this.selectedDay,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      validationError: clearError
          ? null
          : (validationError ?? this.validationError),
      saveSuccess: saveSuccess ?? this.saveSuccess,
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }
}

class CoachAvailabilityFailure extends CoachAvailabilityState {
  final String errorMessage;

  const CoachAvailabilityFailure({required this.errorMessage});
}
