import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';

sealed class TraineeProfileState {
  const TraineeProfileState();
}

class TraineeProfileInitialState extends TraineeProfileState {
  const TraineeProfileInitialState();
}

class TraineeProfileLoadingState extends TraineeProfileState {
  const TraineeProfileLoadingState();
}

class TraineeProfileSuccessState extends TraineeProfileState {
  final TraineeProfileModel profile;

  const TraineeProfileSuccessState(this.profile);
}

class TraineeProfileErrorState extends TraineeProfileState {
  final String errorMessage;

  const TraineeProfileErrorState(this.errorMessage);
}
