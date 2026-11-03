import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repos/trainee_profile_repo.dart';
import '../../helpers/training_insights_calculator.dart';
import '../../helpers/training_period_navigator.dart';
import 'training_insights_state.dart';

class TrainingInsightsCubit extends Cubit<TrainingInsightsState> {
  final TraineeProfileRepo repository;

  TrainingInsightsCubit({required this.repository})
    : super(TrainingInsightsState(selectedDate: DateTime.now()));

  Future<void> loadInsights() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await repository.getTraineeBookings();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.errorMessage),
      ),
      (bookings) => emit(state.copyWith(isLoading: false, bookings: bookings)),
    );
  }

  void selectPeriod(TrainingPeriod period) {
    if (state.selectedPeriod == period) return;
    emit(state.copyWith(selectedPeriod: period, selectedDate: DateTime.now()));
  }

  void previousPeriod() {
    final prev = TrainingPeriodNavigator.computePreviousDate(
      state.selectedPeriod,
      state.selectedDate,
    );
    emit(state.copyWith(selectedDate: prev));
  }

  void nextPeriod() {
    if (!state.canGoForward) return;
    final next = TrainingPeriodNavigator.computeNextDate(
      state.selectedPeriod,
      state.selectedDate,
    );
    emit(state.copyWith(selectedDate: next));
  }
}
