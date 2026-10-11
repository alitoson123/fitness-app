import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:fitness_app/features/coach_availability/data/repos/coach_availability_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'availability_validation_error.dart';
import 'coach_availability_states.dart';

class CoachAvailabilityCubit extends Cubit<CoachAvailabilityState> {
  final CoachAvailabilityRepo repository;

  CoachAvailabilityCubit({required this.repository})
    : super(const CoachAvailabilityInitial());

  Future<void> loadAvailability(String coachUid) async {
    emit(const CoachAvailabilityLoading());
    LoggerService.info('Loading schedule for coach: $coachUid');

    final result = await repository.getCoachProfile(coachUid);
    result.fold(
      (failure) =>
          emit(CoachAvailabilityFailure(errorMessage: failure.errorMessage)),
      (profile) {
        final schedule = profile.weeklyAvailability.isNotEmpty
            ? profile.weeklyAvailability
            : DayAvailability.defaultSchedule();

        emit(
          CoachAvailabilityLoaded(
            schedule: schedule,
            sessionDurationMinutes: profile.sessionDurationMinutes > 0
                ? profile.sessionDurationMinutes
                : 60,
            selectedDay: schedule
                .firstWhere((d) => d.isAvailable, orElse: () => schedule.first)
                .day,
          ),
        );
      },
    );
  }

  void selectDay(DayOfWeek day) {
    if (state is! CoachAvailabilityLoaded) return;
    final curr = state as CoachAvailabilityLoaded;
    emit(curr.copyWith(selectedDay: day, clearError: true, clearInfo: true));
  }

  void toggleDay(DayOfWeek day) {
    if (state is! CoachAvailabilityLoaded) return;
    final curr = state as CoachAvailabilityLoaded;
    final updated = curr.schedule.map((DayAvailability d) {
      return d.day == day ? d.copyWith(isAvailable: !d.isAvailable) : d;
    }).toList();
    emit(curr.copyWith(schedule: updated, clearError: true, clearInfo: true));
  }

  void setDayAvailable(DayOfWeek day, bool isAvailable) {
    if (state is! CoachAvailabilityLoaded) return;
    final curr = state as CoachAvailabilityLoaded;
    final updated = curr.schedule.map((DayAvailability d) {
      return d.day == day ? d.copyWith(isAvailable: isAvailable) : d;
    }).toList();
    emit(curr.copyWith(schedule: updated, clearError: true, clearInfo: true));
  }

  void updateDayTime(DayOfWeek day, {TimeOfDay? fromTime, TimeOfDay? toTime}) {
    if (state is! CoachAvailabilityLoaded) return;
    final curr = state as CoachAvailabilityLoaded;
    final updated = curr.schedule.map((DayAvailability d) {
      if (d.day == day) {
        return d.copyWith(
          fromTime: fromTime ?? d.fromTime,
          toTime: toTime ?? d.toTime,
        );
      }
      return d;
    }).toList();
    emit(curr.copyWith(schedule: updated, clearError: true, clearInfo: true));
  }

  void applyCurrentTimesToAllActiveDays() {
    if (state is! CoachAvailabilityLoaded) return;
    final curr = state as CoachAvailabilityLoaded;
    final currentDay = curr.currentDayAvailability;
    final updated = curr.schedule.map((DayAvailability d) {
      if (d.isAvailable) {
        return d.copyWith(
          fromTime: currentDay.fromTime,
          toTime: currentDay.toTime,
        );
      }
      return d;
    }).toList();

    emit(
      curr.copyWith(
        schedule: updated,
        clearError: true,
        infoMessage: 'applied_to_all',
      ),
    );
  }

  void setSessionDuration(int minutes) {
    if (state is! CoachAvailabilityLoaded) return;
    final curr = state as CoachAvailabilityLoaded;
    emit(
      curr.copyWith(
        sessionDurationMinutes: minutes,
        clearError: true,
        clearInfo: true,
      ),
    );
  }

  AvailabilityValidationError? validateSchedule(
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

  Future<void> saveAvailability(String coachUid) async {
    if (state is! CoachAvailabilityLoaded) return;
    final curr = state as CoachAvailabilityLoaded;

    final validationErr = validateSchedule(
      curr.schedule,
      curr.sessionDurationMinutes,
    );
    if (validationErr != null) {
      emit(curr.copyWith(validationError: validationErr, isSaving: false));
      return;
    }

    emit(curr.copyWith(isSaving: true, clearError: true, clearInfo: true));
    final result = await repository.updateCoachAvailability(
      coachUid: coachUid,
      schedule: curr.schedule,
      sessionDurationMinutes: curr.sessionDurationMinutes,
    );

    result.fold(
      (failure) => emit(
        curr.copyWith(isSaving: false, errorMessage: failure.errorMessage),
      ),
      (success) => emit(curr.copyWith(isSaving: false, saveSuccess: true)),
    );
  }

  void clearMessages() {
    if (state is CoachAvailabilityLoaded) {
      final curr = state as CoachAvailabilityLoaded;
      emit(
        curr.copyWith(clearError: true, clearInfo: true, saveSuccess: false),
      );
    }
  }
}
