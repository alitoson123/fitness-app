import 'coach_setup_cubit.dart';

class CoachSetupValidator {
  static String? validateCubit(int step, CoachSetupCubit c) => validateStep(
        step: step,
        photoUrl: c.photoUrl,
        name: c.name,
        country: c.country,
        city: c.city,
        age: c.age,
        gender: c.gender,
        bio: c.bio,
        selectedLanguages: c.selectedLanguages,
        selectedSports: c.selectedSports,
        sessionPriceUSD: c.sessionPriceUSD,
        monthlyPriceUSD: c.monthlyPriceUSD,
        availabilitySummary: c.availabilitySummary,
        identityDocumentUrl: c.identityDocumentUrl,
        certificateUrls: c.certificateUrls,
      );

  static String? validateStep({
    required int step,
    required String photoUrl,
    required String name,
    required String country,
    required String city,
    int age = 0,
    String gender = '',
    required String bio,
    required List<String> selectedLanguages,
    required List<String> selectedSports,
    double sessionPriceUSD = 0.0,
    double monthlyPriceUSD = 0.0,
    double? hourlyRate,
    required String availabilitySummary,
    required String identityDocumentUrl,
    required List<String> certificateUrls,
  }) {
    if (step == 0) {
      if (photoUrl.isEmpty) return 'photo_required';
      if (name.trim().isEmpty) return 'name_required';
      if (country.isEmpty) return 'country_required';
      if (city.isEmpty) return 'city_required';
      if (age <= 0 || age < 18 || age > 80) return 'age_required';
      if (gender.isEmpty) return 'gender_required';
      if (bio.trim().length < 30) return 'bio_min_length';
      if (selectedLanguages.isEmpty) return 'language_required';
    } else if (step == 1) {
      if (selectedSports.isEmpty) return 'sport_required';
    } else if (step == 2) {
      final sPrice = sessionPriceUSD > 0 ? sessionPriceUSD : (hourlyRate ?? 0.0);
      if (sPrice <= 0) return 'session_rate_required';
      if (monthlyPriceUSD <= 0) return 'monthly_rate_required';
    } else if (step == 3) {
      if (availabilitySummary.trim().isEmpty) return 'availability_required';
    } else if (step == 4) {
      if (identityDocumentUrl.isEmpty) return 'id_required';
      if (certificateUrls.where((u) => u.isNotEmpty).isEmpty) {
        return 'cert_required';
      }
    }
    return null;
  }
}
