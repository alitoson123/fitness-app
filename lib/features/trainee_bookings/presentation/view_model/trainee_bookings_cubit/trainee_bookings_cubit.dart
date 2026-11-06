import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
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
      (bookings) => emit(state.copyWith(allBookings: bookings, isLoading: false)),
      onError: (err) => emit(state.copyWith(isLoading: false, errorMessage: err.toString())),
    );
  }

  void changeTab(TraineeBookingTab tab) => emit(state.copyWith(selectedTab: tab));

  Future<void> _runAction(
    String bookingId,
    Future<Either<Failure, void>> Function() action,
    String successMsg,
  ) async {
    emit(state.copyWith(actionInProgressBookingId: bookingId));
    final res = await action();
    res.fold(
      (f) => emit(state.copyWith(clearActionId: true, errorMessage: f.errorMessage)),
      (_) => emit(state.copyWith(clearActionId: true, successMessage: successMsg)),
    );
  }

  Future<void> acceptReschedule(BookingModel booking) => _runAction(
        booking.id,
        () => repository.acceptReschedule(booking: booking),
        'reschedule_approved',
      );

  Future<void> approveReschedule(BookingModel booking) => acceptReschedule(booking);

  Future<void> declineReschedule(String bookingId, {String? declineReason}) =>
      _runAction(
        bookingId,
        () => repository.declineReschedule(
          bookingId: bookingId,
          declineReason: declineReason,
        ),
        'reschedule_rejected',
      );

  Future<void> rejectReschedule(String bookingId, {String? declineReason}) =>
      declineReschedule(bookingId, declineReason: declineReason);

  Future<void> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) =>
      _runAction(
        booking.id,
        () => repository.requestReschedule(
          booking: booking,
          proposedDate: proposedDate,
          proposedStartTime: proposedStartTime,
          proposedEndTime: proposedEndTime,
          reason: reason,
        ),
        'rescheduled',
      );

  Future<void> requestMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) =>
      _runAction(
        bookingId,
        () => repository.requestMonthlySessionReschedule(
          bookingId: bookingId,
          sessionId: sessionId,
          proposedDate: proposedDate,
          proposedStartTime: proposedStartTime,
          proposedEndTime: proposedEndTime,
          reason: reason,
        ),
        'rescheduled',
      );

  Future<void> acceptMonthlySessionReschedule(String bookingId, String sessionId) =>
      _runAction(
        bookingId,
        () => repository.acceptMonthlySessionReschedule(
          bookingId: bookingId,
          sessionId: sessionId,
        ),
        'reschedule_approved',
      );

  Future<void> declineMonthlySessionReschedule(
    String bookingId,
    String sessionId, {
    String? reason,
  }) =>
      _runAction(
        bookingId,
        () => repository.declineMonthlySessionReschedule(
          bookingId: bookingId,
          sessionId: sessionId,
          declineReason: reason,
        ),
        'reschedule_rejected',
      );

  void clearMessages() => emit(state.copyWith(clearMessages: true));

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
