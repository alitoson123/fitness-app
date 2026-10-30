import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/repos/booking_request_repo.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_request_state.dart';
import 'booking_slot_calculator.dart';

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

  void selectWeeklyFrequency(int freq) {
    emit(state.copyWith(weeklyFrequency: freq));
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

    final dateStr = _formatDate(date);
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

  void selectSlot(String slot) => emit(state.copyWith(selectedSlot: slot));

  void selectSport(String sport) => emit(state.copyWith(selectedSport: sport));

  void updateNotes(String notes) => emit(state.copyWith(notes: notes));

  Future<void> submitBooking() async {
    if (!state.isSubmitReady) return;
    emit(state.copyWith(status: BookingRequestStatus.submitting));

    final trainee = await repository.getCurrentTrainee();
    final traineeUid = repository.authService.currentUser?.uid ?? '';
    final booking = _buildBookingModel(traineeUid, trainee?.name, trainee?.photoUrl);

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

  BookingModel _buildBookingModel(
    String traineeUid,
    String? traineeName,
    String? traineePhotoUrl,
  ) {
    final coach = state.coach!;
    final dateStr = _formatDate(state.selectedDate!);
    final isSession = state.isSession;
    final slot = state.selectedSlot ?? 'Flexible';
    final endTime = isSession
        ? BookingSlotCalculator.computeEndTime(slot, coach.sessionDurationMinutes)
        : 'Flexible';

    return BookingModel(
      id: '',
      coachUid: coach.uid,
      coachName: coach.name,
      coachPhotoUrl: coach.photoUrl,
      traineeUid: traineeUid,
      traineeName: traineeName?.isNotEmpty == true
          ? traineeName!
          : (repository.authService.currentUser?.displayName ?? 'Trainee'),
      traineePhotoUrl: traineePhotoUrl ?? '',
      sport: state.selectedSport!,
      bookingType: state.bookingType,
      date: dateStr,
      startTime: slot,
      endTime: endTime,
      price: state.totalPrice,
      currency: 'USD',
      durationMonths: isSession ? 1 : state.durationMonths,
      notes: state.notes,
      status: 'pending',
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
