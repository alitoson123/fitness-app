import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';

enum TraineeBookingTab { active, history }

class TraineeBookingsState {
  final List<BookingModel> allBookings;
  final TraineeBookingTab selectedTab;
  final bool isLoading;
  final String? actionInProgressBookingId;
  final String? errorMessage;
  final String? successMessage;

  const TraineeBookingsState({
    this.allBookings = const [],
    this.selectedTab = TraineeBookingTab.active,
    this.isLoading = true,
    this.actionInProgressBookingId,
    this.errorMessage,
    this.successMessage,
  });

  List<BookingModel> get activeBookings => allBookings
      .where((b) =>
          b.status == 'confirmed' ||
          b.status == 'pending' ||
          b.status == 'reschedule_pending')
      .toList();

  List<BookingModel> get historyBookings => allBookings
      .where((b) =>
          b.status == 'completed' ||
          b.status == 'rejected' ||
          b.status == 'cancelled')
      .toList();

  List<BookingModel> get currentTabBookings =>
      selectedTab == TraineeBookingTab.active ? activeBookings : historyBookings;

  int get activeCount => activeBookings.length;
  int get historyCount => historyBookings.length;

  TraineeBookingsState copyWith({
    List<BookingModel>? allBookings,
    TraineeBookingTab? selectedTab,
    bool? isLoading,
    String? actionInProgressBookingId,
    String? errorMessage,
    String? successMessage,
    bool clearActionId = false,
    bool clearMessages = false,
  }) {
    return TraineeBookingsState(
      allBookings: allBookings ?? this.allBookings,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      actionInProgressBookingId: clearActionId
          ? null
          : (actionInProgressBookingId ?? this.actionInProgressBookingId),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}
