import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/trainee_discovery/data/models/discovery_filter_model.dart';
import 'package:fitness_app/features/trainee_discovery/data/models/discovery_sort_option.dart';
import 'package:fitness_app/features/trainee_discovery/data/repos/discovery_repo.dart';
import 'package:fitness_app/features/trainee_discovery/presentation/view_model/coach_discovery_cubit/coach_discovery_cubit.dart';
import 'package:fitness_app/features/trainee_discovery/presentation/view_model/coach_discovery_cubit/coach_discovery_states.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDiscoveryRepo implements DiscoveryRepo {
  bool shouldFail = false;
  List<CoachProfileModel> mockCoaches = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<Failure, List<CoachProfileModel>>> getApprovedCoaches() async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage: 'Network error'));
    }
    return Right(mockCoaches);
  }
}

void main() {
  group('CoachDiscoveryCubit Tests', () {
    late FakeDiscoveryRepo fakeRepo;
    late CoachDiscoveryCubit cubit;

    final coach1 = CoachProfileModel(
      uid: 'c1',
      name: 'Ahmed Hassan',
      sports: const ['Football', 'Gym'],
      sessionPrice: 100.0,
      yearsOfExperience: 5,
      gender: 'male',
      rating: 4.8,
      reviewsCount: 10,
    );

    final coach2 = CoachProfileModel(
      uid: 'c2',
      name: 'Sara Ali',
      sports: const ['Swimming', 'Gym'],
      sessionPrice: 200.0,
      yearsOfExperience: 2,
      gender: 'female',
      rating: 4.2,
      reviewsCount: 5,
    );

    setUp(() {
      fakeRepo = FakeDiscoveryRepo()..mockCoaches = [coach1, coach2];
      cubit = CoachDiscoveryCubit(repository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is CoachDiscoveryInitial', () {
      expect(cubit.state, isA<CoachDiscoveryInitial>());
    });

    test('loadCoaches emits Loaded state with coaches', () async {
      await cubit.loadCoaches();
      expect(cubit.state, isA<CoachDiscoveryLoaded>());
      final state = cubit.state as CoachDiscoveryLoaded;
      expect(state.allCoaches.length, 2);
      expect(state.filteredCoaches.length, 2);
    });

    test('loadCoaches emits Error state on failure', () async {
      fakeRepo.shouldFail = true;
      await cubit.loadCoaches();
      expect(cubit.state, isA<CoachDiscoveryError>());
    });

    test('search filters coaches by name and sport', () async {
      await cubit.loadCoaches();

      cubit.search('Ahmed');
      var state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.length, 1);
      expect(state.filteredCoaches.first.name, 'Ahmed Hassan');

      cubit.search('Swimming');
      state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.length, 1);
      expect(state.filteredCoaches.first.name, 'Sara Ali');
    });

    test('selectSport filters correctly and toggles off on re-select', () async {
      await cubit.loadCoaches();

      cubit.selectSport('Football');
      var state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.length, 1);
      expect(state.filteredCoaches.first.uid, 'c1');

      cubit.selectSport('Football');
      state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.length, 2);
    });

    test('applyFilters filters by gender, price and rating', () async {
      await cubit.loadCoaches();

      cubit.applyFilters(
        const DiscoveryFilterModel(
          gender: 'female',
          minPrice: 150.0,
          maxPrice: 300.0,
        ),
      );
      var state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.length, 1);
      expect(state.filteredCoaches.first.uid, 'c2');
    });

    test('sortOption sorts by price low to high and high to low', () async {
      await cubit.loadCoaches();

      cubit.applyFilters(
        const DiscoveryFilterModel(sortOption: DiscoverySortOption.priceLowToHigh),
      );
      var state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.first.sessionPrice, 100.0);

      cubit.applyFilters(
        const DiscoveryFilterModel(sortOption: DiscoverySortOption.priceHighToLow),
      );
      state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.first.sessionPrice, 200.0);
    });

    test('clearFilters resets all filtering back to default', () async {
      await cubit.loadCoaches();
      cubit.selectSport('Football');
      cubit.search('Ahmed');

      cubit.clearFilters();
      final state = cubit.state as CoachDiscoveryLoaded;
      expect(state.filteredCoaches.length, 2);
      expect(state.searchQuery, '');
      expect(state.filter.isDefault, true);
    });

    test('refreshCoaches updates list while preserving active filter and query',
        () async {
      await cubit.loadCoaches();
      cubit.search('Ahmed');

      fakeRepo.mockCoaches = [
        coach1,
        const CoachProfileModel(
          uid: 'c3',
          name: 'Ahmed Youssef',
          sports: ['Gym'],
        ),
      ];

      await cubit.refreshCoaches();
      final state = cubit.state as CoachDiscoveryLoaded;
      expect(state.searchQuery, 'Ahmed');
      expect(state.allCoaches.length, 2);
      expect(state.filteredCoaches.length, 2);
    });
  });
}
