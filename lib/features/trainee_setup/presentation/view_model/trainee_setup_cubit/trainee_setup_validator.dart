class TraineeSetupValidator {
  static String? validateStep({
    required int step,
    required String name,
    required String country,
    required String city,
    required int age,
    required String gender,
  }) {
    if (step == 0) {
      if (name.trim().isEmpty) return 'name_required';
      if (country.trim().isEmpty) return 'country_required';
      if (city.trim().isEmpty) return 'city_required';
      if (age <= 0 || age < 12 || age > 99) return 'age_required';
      if (gender.trim().isEmpty) return 'gender_required';
    }
    return null;
  }
}
