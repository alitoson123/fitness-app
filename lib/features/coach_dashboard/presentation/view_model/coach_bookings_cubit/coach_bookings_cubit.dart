import 'dart:async';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/coach_dashboard/data/repos/coach_bookings_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_bookings_states.dart';

class CoachBookingsCubit extends Cubit<CoachBookingsState> {
  final CoachBookingsRepo repository;
  StreamSubscription<List<BookingModel>>? _subscription;

  CoachBookingsCubit({required this.repository})
      : super(const CoachBookingsState());

  void listenToBookings(String coachUid) {
    if (coachUid.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    emit(state.copyWith(isLoading: true));
    _subscription?.cancel();
    _subscription = repository.getCoachBookingsStream(coachUid).listen(
      (bookings) => emit(state.copyWith(allBookings: bookings, isLoading: false)),
      onError: (err) => emit(state.copyWith(isLoading: false, errorMessage: err.toString())),
    );
  }

  void changeTab(CoachBookingTab tab) => emit(state.copyWith(selectedTab: tab));

  Future<void> acceptBooking(String bookingId) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));
    final result = await repository.updateBookingStatus(
      bookingId: bookingId,
      status: 'confirmed',
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'accepted',
      )),
    );
  }

  Future<void> rejectBooking(String bookingId, {String? reason}) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));
    final result = await repository.updateBookingStatus(
      bookingId: bookingId,
      status: 'rejected',
      rejectionReason: reason,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'rejected',
      )),
    );
  }

  Future<void> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) async {
    emit(state.copyWith(actionInProgressBookingId: booking.id));
    final result = await repository.requestReschedule(
      bookingId: booking.id,
      proposedDate: proposedDate,
      proposedStartTime: proposedStartTime,
      proposedEndTime: proposedEndTime,
      reason: reason,
      originalDate: booking.date,
      originalStartTime: booking.startTime,
      originalEndTime: booking.endTime,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'rescheduled',
      )),
    );
  }

  Future<void> acceptReschedule(BookingModel booking) async {
    emit(state.copyWith(actionInProgressBookingId: booking.id));
    final result = await repository.acceptReschedule(booking: booking);
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'reschedule_accepted',
      )),
    );
  }

  Future<void> declineReschedule(
    String bookingId, {
    String? reason,
  }) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));
    final result = await repository.declineReschedule(
      bookingId: bookingId,
      declineReason: reason,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'reschedule_declined',
      )),
    );
  }

  Future<void> requestMonthlySessionReschedule({
    required BookingModel booking,
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) async {
    emit(state.copyWith(actionInProgressBookingId: booking.id));
    final result = await repository.requestMonthlySessionReschedule(
      bookingId: booking.id,
      sessionId: sessionId,
      proposedDate: proposedDate,
      proposedStartTime: proposedStartTime,
      proposedEndTime: proposedEndTime,
      reason: reason,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'rescheduled',
      )),
    );
  }

  Future<void> acceptMonthlySessionReschedule(
    String bookingId,
    String sessionId,
  ) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));
    final result = await repository.acceptMonthlySessionReschedule(
      bookingId: bookingId,
      sessionId: sessionId,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'reschedule_accepted',
      )),
    );
  }

  Future<void> declineMonthlySessionReschedule(
    String bookingId,
    String sessionId, {
    String? reason,
  }) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));
    final result = await repository.declineMonthlySessionReschedule(
      bookingId: bookingId,
      sessionId: sessionId,
      declineReason: reason,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'reschedule_declined',
      )),
    );
  }

  Future<void> markSessionCompleted(
    String bookingId,
    String sessionId,
  ) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));
    final result = await repository.markSessionCompleted(
      bookingId: bookingId,
      sessionId: sessionId,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'session_completed',
      )),
    );
  }

  void clearMessages() => emit(state.copyWith(clearMessages: true));

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
