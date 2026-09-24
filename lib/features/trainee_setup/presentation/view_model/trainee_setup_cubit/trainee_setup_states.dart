abstract class TraineeSetupState {
  const TraineeSetupState();
}

class TraineeSetupInitialState extends TraineeSetupState {
  const TraineeSetupInitialState();
}

class TraineeSetupFormUpdatedState extends TraineeSetupState {
  final int currentStep;
  final String? photoUrl;
  final String gender;
  final String location;
  final List<String> selectedSports;
  final String selectedLevel;
  final String selectedGoal;

  const TraineeSetupFormUpdatedState({
    required this.currentStep,
    this.photoUrl,
    required this.gender,
    required this.location,
    required this.selectedSports,
    required this.selectedLevel,
    required this.selectedGoal,
  });
}

class TraineeSetupLoadingState extends TraineeSetupState {
  const TraineeSetupLoadingState();
}

class TraineeSetupSuccessState extends TraineeSetupState {
  const TraineeSetupSuccessState();
}

class TraineeSetupErrorState extends TraineeSetupState {
  final String errorMessage;

  const TraineeSetupErrorState({required this.errorMessage});
}
