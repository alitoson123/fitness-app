import 'package:fitness_app/features/booking_request/data/repos/booking_request_repo.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_builder_helper.dart';
import 'booking_request_state.dart';
import 'booking_slot_calculator.dart';
import 'monthly_sessions_manager.dart';

class BookingRequestCubit extends Cubit<BookingRequestState> {
  final BookingRequestRepo repository;

  BookingRequestCubit({required this.repository})
      : super(const BookingRequestState());

  void init(CoachProfileModel coach) {
    final now = DateTime.now();
    final dates = List.generate(
      30,
      (i) => DateTime(now.year, now.month, now.day + i),
    );
    final firstWorkingDate = dates.firstWhere(
      (d) => BookingSlotCalculator.isCoachWorkingOnDay(coach, d),
      orElse: () => dates.first,
    );
    final defaultSport =
        coach.sports.isNotEmpty ? coach.sports.first : 'Fitness';

    emit(
      state.copyWith(
        coach: coach,
        availableDates: dates,
        selectedDate: firstWorkingDate,
        selectedSport: defaultSport,
        status: BookingRequestStatus.loadingSlots,
      ),
    );
    loadSlotsForDate(firstWorkingDate);
  }

  void selectBookingType(String type) {
    emit(state.copyWith(bookingType: type));
    if (type == 'session' &&
        state.availableSlots.isEmpty &&
        state.selectedDate != null) {
      loadSlotsForDate(state.selectedDate!);
    }
  }

  Future<void> loadSlotsForDate(DateTime date) async {
    final coach = state.coach;
    if (coach == null) return;

    emit(
      state.copyWith(
        selectedDate: date,
        clearSelectedSlot: true,
        status: BookingRequestStatus.loadingSlots,
      ),
    );

    final dateStr = BookingBuilderHelper.formatDate(date);
    final result = await repository.getBookedSlots(
      coachUid: coach.uid,
      date: dateStr,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingRequestStatus.ready,
          availableSlots: [],
          errorMessage: failure.errorMessage,
        ),
      ),
      (booked) {
        final slots = BookingSlotCalculator.generateDaySlots(
          coach: coach,
          date: date,
          bookedSlots: booked,
        );
        emit(
          state.copyWith(
            status: BookingRequestStatus.ready,
            availableSlots: slots,
          ),
        );
      },
    );
  }

  void selectSlot(String slot) {
    emit(state.copyWith(selectedSlot: slot));
    if (state.isMonthly && state.selectedDate != null) {
      toggleMonthlySession(state.selectedDate!, slot);
    }
  }

  void toggleMonthlySession(DateTime date, String timeSlot) {
    final coach = state.coach;
    if (coach == null) return;
    final updated = MonthlySessionsManager.toggleSession(
      currentSessions: state.selectedMonthlySessions,
      date: date,
      timeSlot: timeSlot,
      sessionDurationMinutes: coach.sessionDurationMinutes,
      maxSessions: state.requiredMonthlySessions,
    );
    emit(state.copyWith(selectedMonthlySessions: updated));
  }

  void removeMonthlySession(String sessionId) {
    final updated = MonthlySessionsManager.removeSession(
      state.selectedMonthlySessions,
      sessionId,
    );
    emit(state.copyWith(selectedMonthlySessions: updated));
  }

  void clearMonthlySessions() {
    emit(state.copyWith(selectedMonthlySessions: const []));
  }

  void selectSport(String sport) => emit(state.copyWith(selectedSport: sport));

  void updateNotes(String notes) => emit(state.copyWith(notes: notes));

  Future<void> submitBooking() async {
    if (!state.isSubmitReady) return;
    emit(state.copyWith(status: BookingRequestStatus.submitting));

    final trainee = await repository.getCurrentTrainee();
    final traineeUid = repository.authService.currentUser?.uid ?? '';
    final booking = BookingBuilderHelper.buildFromState(
      state: state,
      traineeUid: traineeUid,
      traineeName: trainee?.name,
      traineePhotoUrl: trainee?.photoUrl,
    );

    final result = await repository.createBooking(booking);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingRequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (_) => emit(state.copyWith(status: BookingRequestStatus.success)),
    );
  }
}
