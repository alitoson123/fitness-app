class CoachSetupValidator {
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
    required double hourlyRate,
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
      if (hourlyRate <= 0) return 'rate_required';
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
