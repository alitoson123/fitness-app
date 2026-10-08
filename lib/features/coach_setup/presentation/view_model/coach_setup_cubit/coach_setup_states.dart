abstract class CoachSetupState {
  const CoachSetupState();
}

class CoachSetupInitialState extends CoachSetupState {
  const CoachSetupInitialState();
}

class CoachSetupFormUpdatedState extends CoachSetupState {
  final int currentStep;
  final String photoUrl;
  final String name;
  final String bio;
  final String country;
  final String city;
  final int age;
  final String gender;
  final List<String> selectedLanguages;
  final List<String> selectedSports;
  final List<String> specialties;
  final int yearsOfExperience;
  final double sessionPrice;
  final String currency;
  final String availabilitySummary;
  final String identityDocumentUrl;
  final List<String> certificateUrls;
  final String? validationError;

  const CoachSetupFormUpdatedState({
    required this.currentStep,
    required this.photoUrl,
    required this.name,
    required this.bio,
    required this.country,
    required this.city,
    this.age = 0,
    this.gender = 'male',
    required this.selectedLanguages,
    required this.selectedSports,
    required this.specialties,
    required this.yearsOfExperience,
    required this.sessionPrice,
    this.currency = 'USD',
    required this.availabilitySummary,
    required this.identityDocumentUrl,
    required this.certificateUrls,
    this.validationError,
  });
}

class CoachSetupLoadingState extends CoachSetupState {
  const CoachSetupLoadingState();
}

class CoachSetupSuccessState extends CoachSetupState {
  const CoachSetupSuccessState();
}

class CoachSetupErrorState extends CoachSetupState {
  final String errorMessage;

  const CoachSetupErrorState({required this.errorMessage});
}
