import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';
import 'package:fitness_app/features/trainee_setup/data/repos/trainee_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trainee_setup_states.dart';

class TraineeSetupCubit extends Cubit<TraineeSetupState> {
  final TraineeSetupRepo repository;

  int currentStep = 0;
  String? photoUrl;
  String gender = '';
  String location = '';
  List<String> selectedSports = [];
  String selectedLevel = '';
  String selectedGoal = '';

  TraineeSetupCubit({required this.repository})
      : super(const TraineeSetupInitialState()) {
    _emitCurrentForm();
  }

  void _emitCurrentForm() {
    emit(TraineeSetupFormUpdatedState(
      currentStep: currentStep,
      photoUrl: photoUrl,
      gender: gender,
      location: location,
      selectedSports: List.unmodifiable(selectedSports),
      selectedLevel: selectedLevel,
      selectedGoal: selectedGoal,
    ));
  }

  void nextStep() {
    if (currentStep < 3) {
      currentStep++;
      _emitCurrentForm();
    } else {
      submitProfile();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      _emitCurrentForm();
    }
  }

  void skipStep() {
    nextStep();
  }

  void setGender(String newGender) {
    gender = newGender;
    _emitCurrentForm();
  }

  void setLocation(String newLocation) {
    location = newLocation;
    _emitCurrentForm();
  }

  void setPhotoUrl(String? newPhotoUrl) {
    photoUrl = newPhotoUrl;
    _emitCurrentForm();
  }

  void toggleSport(String sport) {
    final updated = List<String>.from(selectedSports);
    if (updated.contains(sport)) {
      updated.remove(sport);
    } else {
      updated.add(sport);
    }
    selectedSports = updated;
    _emitCurrentForm();
  }

  void setLevel(String level) {
    selectedLevel = level;
    _emitCurrentForm();
  }

  void setGoal(String goal) {
    selectedGoal = goal;
    _emitCurrentForm();
  }

  Future<void> submitProfile() async {
    emit(const TraineeSetupLoadingState());
    final profile = TraineeProfileModel(
      uid: '',
      photoUrl: photoUrl,
      gender: gender,
      location: location.trim(),
      sports: selectedSports,
      level: selectedLevel,
      goal: selectedGoal,
      isProfileCompleted: true,
    );

    final result = await repository.saveTraineeProfile(profile);
    result.fold(
      (failure) => emit(TraineeSetupErrorState(errorMessage: failure)),
      (_) => emit(const TraineeSetupSuccessState()),
    );
  }
}
