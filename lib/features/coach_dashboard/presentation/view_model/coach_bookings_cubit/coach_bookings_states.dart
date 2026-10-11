import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';

enum CoachBookingTab { pending, confirmed, past }

class CoachBookingsState {
  final List<BookingModel> allBookings;
  final CoachBookingTab selectedTab;
  final bool isLoading;
  final String? actionInProgressBookingId;
  final String? errorMessage;
  final String? successMessage;

  const CoachBookingsState({
    this.allBookings = const [],
    this.selectedTab = CoachBookingTab.pending,
    this.isLoading = true,
    this.actionInProgressBookingId,
    this.errorMessage,
    this.successMessage,
  });

  List<BookingModel> get pendingBookings =>
      allBookings.where((b) => b.status == 'pending').toList();

  List<BookingModel> get confirmedBookings =>
      allBookings.where((b) => b.status == 'confirmed').toList();

  List<BookingModel> get pastBookings => allBookings
      .where((b) => b.status == 'rejected' || b.status == 'completed')
      .toList();

  List<BookingModel> get currentTabBookings {
    switch (selectedTab) {
      case CoachBookingTab.pending:
        return pendingBookings;
      case CoachBookingTab.confirmed:
        return confirmedBookings;
      case CoachBookingTab.past:
        return pastBookings;
    }
  }

  int get pendingCount => pendingBookings.length;
  int get confirmedCount => confirmedBookings.length;
  int get pastCount => pastBookings.length;

  CoachBookingsState copyWith({
    List<BookingModel>? allBookings,
    CoachBookingTab? selectedTab,
    bool? isLoading,
    String? actionInProgressBookingId,
    String? errorMessage,
    String? successMessage,
    bool clearActionId = false,
    bool clearMessages = false,
  }) {
    return CoachBookingsState(
      allBookings: allBookings ?? this.allBookings,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      actionInProgressBookingId: clearActionId
          ? null
          : (actionInProgressBookingId ?? this.actionInProgressBookingId),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
