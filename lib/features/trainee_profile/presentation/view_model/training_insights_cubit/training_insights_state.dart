import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import '../../helpers/training_insights_calculator.dart';
import '../../helpers/training_period_navigator.dart';

class TrainingInsightsState {
  final TrainingPeriod selectedPeriod;
  final DateTime selectedDate;
  final List<BookingModel> bookings;
  final bool isLoading;
  final String? errorMessage;

  const TrainingInsightsState({
    this.selectedPeriod = TrainingPeriod.day,
    required this.selectedDate,
    this.bookings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  Set<DateTime> get uniqueCompletedDays =>
      TrainingInsightsCalculator.extractUniqueCompletedDays(bookings);

  int get currentPeriodUniqueDays =>
      TrainingInsightsCalculator.calculateUniqueDays(
        completedDays: uniqueCompletedDays,
        period: selectedPeriod,
        referenceDate: selectedDate,
      );

  bool get hasAnyCompletedSessions => uniqueCompletedDays.isNotEmpty;

  bool get canGoForward =>
      TrainingPeriodNavigator.canGoForward(selectedPeriod, selectedDate);

  TrainingInsightsState copyWith({
    TrainingPeriod? selectedPeriod,
    DateTime? selectedDate,
    List<BookingModel>? bookings,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TrainingInsightsState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedDate: selectedDate ?? this.selectedDate,
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
