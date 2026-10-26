import 'dart:async';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/trainee_bookings/data/repos/trainee_bookings_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trainee_bookings_states.dart';

class TraineeBookingsCubit extends Cubit<TraineeBookingsState> {
  final TraineeBookingsRepo repository;
  StreamSubscription<List<BookingModel>>? _subscription;

  TraineeBookingsCubit({required this.repository})
      : super(const TraineeBookingsState());

  void listenToBookings(String traineeUid) {
    if (traineeUid.isEmpty) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true));
    _subscription?.cancel();

    _subscription = repository.getTraineeBookingsStream(traineeUid).listen(
      (bookings) {
        emit(state.copyWith(allBookings: bookings, isLoading: false));
      },
      onError: (err) {
        emit(state.copyWith(isLoading: false, errorMessage: err.toString()));
      },
    );
  }

  void changeTab(TraineeBookingTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  Future<void> approveReschedule(BookingModel booking) async {
    emit(state.copyWith(actionInProgressBookingId: booking.id));

    final result = await repository.approveReschedule(booking: booking);

    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'reschedule_approved',
      )),
    );
  }

  Future<void> rejectReschedule(String bookingId) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));

    final result = await repository.rejectReschedule(bookingId: bookingId);

    result.fold(
      (failure) => emit(state.copyWith(
        clearActionId: true,
        errorMessage: failure.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearActionId: true,
        successMessage: 'reschedule_rejected',
      )),
    );
  }

  void clearMessages() {
    emit(state.copyWith(clearMessages: true));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
