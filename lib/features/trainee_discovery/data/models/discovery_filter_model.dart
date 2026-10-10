import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'discovery_sort_option.dart';

class DiscoveryFilterModel {
  static const double defaultMinPrice = 0.0;
  static const double defaultMaxPrice = 1000.0;

  final String? selectedSport;
  final double minPrice;
  final double maxPrice;
  final int minExperience;
  final String gender; // 'all' | 'male' | 'female'
  final double minRating;
  final DiscoverySortOption sortOption;

  const DiscoveryFilterModel({
    this.selectedSport,
    this.minPrice = defaultMinPrice,
    this.maxPrice = defaultMaxPrice,
    this.minExperience = 0,
    this.gender = 'all',
    this.minRating = 0.0,
    this.sortOption = DiscoverySortOption.recommended,
  });

  bool get isDefault =>
      (selectedSport == null || selectedSport == 'all') &&
      minPrice == defaultMinPrice &&
      maxPrice == defaultMaxPrice &&
      minExperience == 0 &&
      gender == 'all' &&
      minRating == 0.0 &&
      sortOption == DiscoverySortOption.recommended;

  int get activeFiltersCount {
    int count = 0;
    if (minPrice > defaultMinPrice || maxPrice < defaultMaxPrice) count++;
    if (minExperience > 0) count++;
    if (gender != 'all') count++;
    if (minRating > 0.0) count++;
    if (sortOption != DiscoverySortOption.recommended) count++;
    return count;
  }

  bool matches(CoachProfileModel coach) {
    if (selectedSport != null &&
        selectedSport!.isNotEmpty &&
        selectedSport!.toLowerCase() != 'all') {
      final hasSport = coach.sports.any(
        (s) => s.toLowerCase() == selectedSport!.toLowerCase(),
      );
      if (!hasSport) return false;
    }

    if (coach.sessionPrice < minPrice || coach.sessionPrice > maxPrice) {
      return false;
    }

    if (coach.yearsOfExperience < minExperience) {
      return false;
    }

    if (gender != 'all' &&
        coach.gender.toLowerCase() != gender.toLowerCase()) {
      return false;
    }

    if (minRating > 0.0 && coach.rating < minRating) {
      return false;
    }

    return true;
  }

  DiscoveryFilterModel copyWith({
    String? selectedSport,
    double? minPrice,
    double? maxPrice,
    int? minExperience,
    String? gender,
    double? minRating,
    DiscoverySortOption? sortOption,
    bool clearSport = false,
  }) {
    return DiscoveryFilterModel(
      selectedSport: clearSport ? null : (selectedSport ?? this.selectedSport),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minExperience: minExperience ?? this.minExperience,
      gender: gender ?? this.gender,
      minRating: minRating ?? this.minRating,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
