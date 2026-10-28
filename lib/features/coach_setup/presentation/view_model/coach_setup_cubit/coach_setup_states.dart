import 'coach_setup_cubit.dart';

abstract class CoachSetupState {
  const CoachSetupState();
}

class CoachSetupInitialState extends CoachSetupState {
  const CoachSetupInitialState();
}

class CoachSetupFormUpdatedState extends CoachSetupState {
  final int currentStep;
  final String photoUrl, name, bio, country, city, gender, currency;
  final int age, yearsOfExperience;
  final List<String> selectedLanguages, selectedSports, specialties, certificateUrls;
  final double sessionPriceUSD, monthlyPriceUSD;
  final String availabilitySummary, identityDocumentUrl;
  final String? validationError;

  double get sessionPrice => sessionPriceUSD;

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
    double? sessionPrice,
    double? sessionPriceUSD,
    this.monthlyPriceUSD = 0.0,
    this.currency = 'USD',
    required this.availabilitySummary,
    required this.identityDocumentUrl,
    required this.certificateUrls,
    this.validationError,
  }) : sessionPriceUSD = sessionPriceUSD ?? sessionPrice ?? 0.0;

  factory CoachSetupFormUpdatedState.fromCubit(
    CoachSetupCubit c, [
    String? error,
  ]) =>
      CoachSetupFormUpdatedState(
        currentStep: c.currentStep,
        photoUrl: c.photoUrl,
        name: c.name,
        bio: c.bio,
        country: c.country,
        city: c.city,
        age: c.age,
        gender: c.gender,
        selectedLanguages: List.unmodifiable(c.selectedLanguages),
        selectedSports: List.unmodifiable(c.selectedSports),
        specialties: List.unmodifiable(c.specialties),
        yearsOfExperience: c.yearsOfExperience,
        sessionPriceUSD: c.sessionPriceUSD,
        monthlyPriceUSD: c.monthlyPriceUSD,
        currency: c.currency,
        availabilitySummary: c.availabilitySummary,
        identityDocumentUrl: c.identityDocumentUrl,
        certificateUrls: List.unmodifiable(c.certificateUrls),
        validationError: error,
      );
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
