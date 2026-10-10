import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/trainee_discovery/data/models/discovery_filter_model.dart';

abstract class CoachDiscoveryState {
  const CoachDiscoveryState();
}

class CoachDiscoveryInitial extends CoachDiscoveryState {
  const CoachDiscoveryInitial();
}

class CoachDiscoveryLoading extends CoachDiscoveryState {
  const CoachDiscoveryLoading();
}

class CoachDiscoveryLoaded extends CoachDiscoveryState {
  final List<CoachProfileModel> allCoaches;
  final List<CoachProfileModel> filteredCoaches;
  final DiscoveryFilterModel filter;
  final String searchQuery;

  const CoachDiscoveryLoaded({
    required this.allCoaches,
    required this.filteredCoaches,
    this.filter = const DiscoveryFilterModel(),
    this.searchQuery = '',
  });

  CoachDiscoveryLoaded copyWith({
    List<CoachProfileModel>? allCoaches,
    List<CoachProfileModel>? filteredCoaches,
    DiscoveryFilterModel? filter,
    String? searchQuery,
  }) {
    return CoachDiscoveryLoaded(
      allCoaches: allCoaches ?? this.allCoaches,
      filteredCoaches: filteredCoaches ?? this.filteredCoaches,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CoachDiscoveryError extends CoachDiscoveryState {
  final String errorMessage;

  const CoachDiscoveryError({required this.errorMessage});
}
