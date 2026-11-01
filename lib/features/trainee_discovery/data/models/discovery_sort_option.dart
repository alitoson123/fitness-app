import '../../../coach_setup/data/models/coach_profile_model.dart';

enum DiscoverySortOption {
  recommended,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  experienceHighToLow;

  void sort(List<CoachProfileModel> coaches) {
    switch (this) {
      case DiscoverySortOption.priceLowToHigh:
        coaches.sort((a, b) => a.sessionPriceUSD.compareTo(b.sessionPriceUSD));
      case DiscoverySortOption.priceHighToLow:
        coaches.sort((a, b) => b.sessionPriceUSD.compareTo(a.sessionPriceUSD));
      case DiscoverySortOption.ratingHighToLow:
      case DiscoverySortOption.recommended:
        coaches.sort((a, b) => b.rating.compareTo(a.rating));
      case DiscoverySortOption.experienceHighToLow:
        coaches.sort(
          (a, b) => b.yearsOfExperience.compareTo(a.yearsOfExperience),
        );
    }
  }
}
