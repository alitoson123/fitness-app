import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';

class BookingDetailsState {
  final BookingModel? booking;
  final bool isLoading;
  final bool isActionInProgress;
  final String? actionSessionId;
  final String? errorMessage;
  final String? successMessage;

  const BookingDetailsState({
    this.booking,
    this.isLoading = false,
    this.isActionInProgress = false,
    this.actionSessionId,
    this.errorMessage,
    this.successMessage,
  });

  BookingDetailsState copyWith({
    BookingModel? booking,
    bool? isLoading,
    bool? isActionInProgress,
    String? actionSessionId,
    String? errorMessage,
    String? successMessage,
    bool clearAction = false,
    bool clearMessages = false,
  }) {
    return BookingDetailsState(
      booking: booking ?? this.booking,
      isLoading: isLoading ?? this.isLoading,
      isActionInProgress:
          clearAction ? false : (isActionInProgress ?? this.isActionInProgress),
      actionSessionId:
          clearAction ? null : (actionSessionId ?? this.actionSessionId),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}
