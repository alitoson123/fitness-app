import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/trainee_discovery/data/models/discovery_filter_model.dart';
import 'package:fitness_app/features/trainee_discovery/data/repos/discovery_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_discovery_states.dart';

class CoachDiscoveryCubit extends Cubit<CoachDiscoveryState> {
  final DiscoveryRepo repository;

  CoachDiscoveryCubit({required this.repository})
      : super(const CoachDiscoveryInitial());

  Future<void> loadCoaches() async {
    emit(const CoachDiscoveryLoading());
    await _fetchCoaches(resetState: true);
  }

  Future<void> refreshCoaches() async {
    await _fetchCoaches(resetState: false);
  }

  Future<void> _fetchCoaches({required bool resetState}) async {
    final currentState = state;
    final result = await repository.getApprovedCoaches();

    result.fold(
      (failure) {
        if (!resetState && currentState is CoachDiscoveryLoaded) return;
        emit(CoachDiscoveryError(errorMessage: failure.errorMessage));
      },
      (coaches) {
        final filter = (!resetState && currentState is CoachDiscoveryLoaded)
            ? currentState.filter
            : const DiscoveryFilterModel();
        final query = (!resetState && currentState is CoachDiscoveryLoaded)
            ? currentState.searchQuery
            : '';
        final filtered = _filterAndSort(coaches, filter, query);
        emit(
          CoachDiscoveryLoaded(
            allCoaches: coaches,
            filteredCoaches: filtered,
            filter: filter,
            searchQuery: query,
          ),
        );
      },
    );
  }

  void search(String query) {
    final s = state;
    if (s is! CoachDiscoveryLoaded) return;
    final filtered = _filterAndSort(s.allCoaches, s.filter, query);
    emit(s.copyWith(searchQuery: query, filteredCoaches: filtered));
  }

  void selectSport(String? sport) {
    final s = state;
    if (s is! CoachDiscoveryLoaded) return;
    final isAll = sport == null || sport.toLowerCase() == 'all';
    final newSport = isAll ? null : (s.filter.selectedSport == sport ? null : sport);
    final updated = s.filter.copyWith(selectedSport: newSport, clearSport: newSport == null);
    final filtered = _filterAndSort(s.allCoaches, updated, s.searchQuery);
    emit(s.copyWith(filter: updated, filteredCoaches: filtered));
  }

  void applyFilters(DiscoveryFilterModel newFilter) {
    final s = state;
    if (s is! CoachDiscoveryLoaded) return;
    final filtered = _filterAndSort(s.allCoaches, newFilter, s.searchQuery);
    emit(s.copyWith(filter: newFilter, filteredCoaches: filtered));
  }

  void clearFilters() {
    final s = state;
    if (s is! CoachDiscoveryLoaded) return;
    const reset = DiscoveryFilterModel();
    emit(s.copyWith(
      filter: reset,
      searchQuery: '',
      filteredCoaches: _filterAndSort(s.allCoaches, reset, ''),
    ));
  }

  List<CoachProfileModel> _filterAndSort(
    List<CoachProfileModel> coaches,
    DiscoveryFilterModel filter,
    String query,
  ) {
    final trimmed = query.trim().toLowerCase();

    final filtered = coaches.where((coach) {
      if (!filter.matches(coach)) return false;

      if (trimmed.isNotEmpty) {
        final matchesName = coach.name.toLowerCase().contains(trimmed);
        final matchesSport = coach.sports.any(
          (s) => s.toLowerCase().contains(trimmed),
        );
        if (!matchesName && !matchesSport) return false;
      }
      return true;
    }).toList();

    filter.sortOption.sort(filtered);
    return filtered;
  }
}
