import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/trainee_profile_model.dart';
import '../../../data/repos/trainee_setup_repo.dart';
import 'trainee_setup_states.dart';
import 'trainee_setup_validator.dart';

class TraineeSetupCubit extends Cubit<TraineeSetupState> {
  final TraineeSetupRepo repository;

  int currentStep = 0;
  String? photoUrl;
  String name = '';
  String country = '';
  String city = '';
  int age = 0;
  String gender = '';
  List<String> selectedSports = [];
  String selectedLevel = '';
  String selectedGoal = '';

  TraineeSetupCubit({required this.repository})
    : super(const TraineeSetupInitialState()) {
    _emitCurrentForm();
  }

  void _emitCurrentForm([String? error]) {
    emit(
      TraineeSetupFormUpdatedState(
        currentStep: currentStep,
        photoUrl: photoUrl,
        name: name,
        country: country,
        city: city,
        age: age,
        gender: gender,
        selectedSports: List.unmodifiable(selectedSports),
        selectedLevel: selectedLevel,
        selectedGoal: selectedGoal,
        validationError: error,
      ),
    );
  }

  Future<void> loadInitialData() async {
    final profile = await repository.getTraineeProfile();
    if (profile != null) {
      _applyProfile(profile);
      return;
    }
  }

  void _applyProfile(TraineeProfileModel p) {
    name = p.name;
    photoUrl = p.photoUrl;
    country = p.country;
    city = p.city;
    age = p.age;
    gender = p.gender;
    selectedSports = List.from(p.sports);
    selectedLevel = p.level;
    selectedGoal = p.goal;
    _emitCurrentForm();
  }

  void setName(String val) {
    name = val;
    _emitCurrentForm();
  }

  void setCountry(String val) {
    country = val;
    city = '';
    _emitCurrentForm();
  }

  void setCity(String val) {
    city = val;
    _emitCurrentForm();
  }

  void setAge(int val) {
    age = val;
    _emitCurrentForm();
  }

  void setGender(String val) {
    gender = val;
    _emitCurrentForm();
  }

  void setPhotoUrl(String? val) {
    photoUrl = val;
    _emitCurrentForm();
  }

  void setLevel(String val) {
    selectedLevel = val;
    _emitCurrentForm();
  }

  void setGoal(String val) {
    selectedGoal = val;
    _emitCurrentForm();
  }

  void toggleSport(String sport) {
    final updated = List<String>.from(selectedSports);
    updated.contains(sport) ? updated.remove(sport) : updated.add(sport);
    selectedSports = updated;
    _emitCurrentForm();
  }

  bool validateStep(int step) {
    final err = TraineeSetupValidator.validateStep(
      step: step,
      name: name,
      country: country,
      city: city,
      age: age,
      gender: gender,
    );
    if (err != null) {
      _emitCurrentForm(err);
      return false;
    }
    return true;
  }

  void nextStep() {
    if (!validateStep(currentStep)) return;
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

  void goToStep(int step) {
    if (step >= 0 && step <= 3) {
      currentStep = step;
      _emitCurrentForm();
    }
  }

  void skipStep() {
    if (currentStep < 3) {
      currentStep++;
      _emitCurrentForm();
    } else {
      submitProfile();
    }
  }

  Future<void> submitProfile() async {
    emit(const TraineeSetupLoadingState());
    final profile = TraineeProfileModel(
      uid: '',
      name: name.trim(),
      country: country.trim(),
      city: city.trim(),
      age: age,
      photoUrl: photoUrl,
      gender: gender,
      sports: selectedSports,
      level: selectedLevel,
      goal: selectedGoal,
      isProfileCompleted: true,
      updatedAt: DateTime.now(),
    );
    final result = await repository.saveTraineeProfile(profile);
    result.fold(
      (failure) => emit(TraineeSetupErrorState(errorMessage: failure)),
      (_) => emit(const TraineeSetupSuccessState()),
    );
  }
}
