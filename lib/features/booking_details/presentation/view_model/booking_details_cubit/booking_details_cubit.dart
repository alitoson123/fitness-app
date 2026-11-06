import 'dart:async';
import 'package:fitness_app/features/booking_details/data/repos/booking_details_repo.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final BookingDetailsRepo repository;
  StreamSubscription<BookingModel>? _subscription;

  BookingDetailsCubit({required this.repository})
      : super(const BookingDetailsState());

  void init(BookingModel initialBooking) {
    emit(state.copyWith(booking: initialBooking, isLoading: false));
    _listenToBooking(initialBooking.id);
  }

  void _listenToBooking(String bookingId) {
    _subscription?.cancel();
    _subscription = repository.streamBooking(bookingId).listen(
      (updated) => emit(state.copyWith(booking: updated)),
      onError: (e) => emit(state.copyWith(errorMessage: e.toString())),
    );
  }

  Future<void> acceptBooking() async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.updateBookingStatus(
      bookingId: b.id,
      status: 'confirmed',
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'accepted',
      )),
    );
  }

  Future<void> rejectBooking({String? reason}) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.updateBookingStatus(
      bookingId: b.id,
      status: 'rejected',
      rejectionReason: reason,
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'rejected',
      )),
    );
  }

  Future<void> requestReschedule({
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String rescheduledBy,
  }) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.requestReschedule(
      booking: b,
      proposedDate: proposedDate,
      proposedStartTime: proposedStartTime,
      proposedEndTime: proposedEndTime,
      reason: reason,
      rescheduledBy: rescheduledBy,
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'rescheduled',
      )),
    );
  }

  Future<void> acceptReschedule() async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.acceptReschedule(booking: b);
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'reschedule_accepted',
      )),
    );
  }

  Future<void> declineReschedule({String? reason}) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.declineReschedule(
      bookingId: b.id,
      declineReason: reason,
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'reschedule_declined',
      )),
    );
  }

  Future<void> markSessionCompleted(String sessionId) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(
      isActionInProgress: true,
      actionSessionId: sessionId,
      clearMessages: true,
    ));
    final res = await repository.markSessionCompleted(
      bookingId: b.id,
      sessionId: sessionId,
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'session_completed',
      )),
    );
  }

  Future<void> requestMonthlySessionReschedule({
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String rescheduledBy,
  }) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(
      isActionInProgress: true,
      actionSessionId: sessionId,
      clearMessages: true,
    ));
    final res = await repository.requestMonthlySessionReschedule(
      bookingId: b.id,
      sessionId: sessionId,
      proposedDate: proposedDate,
      proposedStartTime: proposedStartTime,
      proposedEndTime: proposedEndTime,
      reason: reason,
      rescheduledBy: rescheduledBy,
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'rescheduled',
      )),
    );
  }

  Future<void> acceptMonthlySessionReschedule(String sessionId) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(
      isActionInProgress: true,
      actionSessionId: sessionId,
      clearMessages: true,
    ));
    final res = await repository.acceptMonthlySessionReschedule(
      bookingId: b.id,
      sessionId: sessionId,
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'reschedule_accepted',
      )),
    );
  }

  Future<void> declineMonthlySessionReschedule(
    String sessionId, {
    String? reason,
  }) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(
      isActionInProgress: true,
      actionSessionId: sessionId,
      clearMessages: true,
    ));
    final res = await repository.declineMonthlySessionReschedule(
      bookingId: b.id,
      sessionId: sessionId,
      declineReason: reason,
    );
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'reschedule_declined',
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
