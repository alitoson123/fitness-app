abstract class TraineeSetupState {
  const TraineeSetupState();
}

class TraineeSetupInitialState extends TraineeSetupState {
  const TraineeSetupInitialState();
}

class TraineeSetupFormUpdatedState extends TraineeSetupState {
  final int currentStep;
  final String? photoUrl;
  final String name;
  final String country;
  final String city;
  final int age;
  final String gender;
  final List<String> selectedSports;
  final String selectedLevel;
  final String selectedGoal;
  final String? validationError;

  const TraineeSetupFormUpdatedState({
    required this.currentStep,
    this.photoUrl,
    this.name = '',
    this.country = '',
    this.city = '',
    this.age = 0,
    required this.gender,
    required this.selectedSports,
    required this.selectedLevel,
    required this.selectedGoal,
    this.validationError,
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
