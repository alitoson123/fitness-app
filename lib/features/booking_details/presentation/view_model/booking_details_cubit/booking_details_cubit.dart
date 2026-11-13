import 'dart:async';
import 'package:fitness_app/features/booking_details/data/repos/booking_details_repo.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/generated/l10n.dart';
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
      onError: (_) => emit(
        state.copyWith(errorMessage: S.current.unexpectedErrorMessage),
      ),
    );
  }

  Future<void> acceptBooking() async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.approve(b.id);
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
    final res = await repository.reject(b.id, reason: reason);
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
  }) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.requestReschedule(
      bookingId: b.id,
      proposedDate: proposedDate,
      proposedStartTime: proposedStartTime,
      proposedEndTime: proposedEndTime,
      reason: reason,
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
    final res = await repository.acceptReschedule(b.id);
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
      b.id,
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

  /// Trainee: cancel the booking (or withdraw a request).
  Future<void> cancelBooking({String? reason}) async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.cancel(b.id, reason: reason);
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'booking_cancelled',
      )),
    );
  }

  /// Coach: single-session booking took place.
  Future<void> completeBooking() async {
    final b = state.booking;
    if (b == null) return;
    emit(state.copyWith(isActionInProgress: true, clearMessages: true));
    final res = await repository.completeBooking(b.id);
    res.fold(
      (f) => emit(state.copyWith(
        clearAction: true,
        errorMessage: f.errorMessage,
      )),
      (_) => emit(state.copyWith(
        clearAction: true,
        successMessage: 'booking_completed',
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

  Future<void> declineMonthlySessionReschedule(String sessionId) async {
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
