import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_validator.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCoachSetupRepo implements CoachSetupRepo {
  Map<String, dynamic>? lastDraftData;

  @override
  Future<Either<Failure, CoachApplicationModel?>>
  getCoachApplicationStatus() async => const Right(null);
  @override
  Stream<CoachApplicationModel?> streamCoachApplicationStatus() =>
      const Stream.empty();
  @override
  Future<Either<Failure, CoachProfileModel?>> getCoachProfile() async =>
      const Right(null);
  @override
  Future<Either<Failure, Map<String, dynamic>?>> getDraftApplication() async =>
      Right(lastDraftData);
  @override
  Future<Either<Failure, void>> saveDraftApplication({
    required Map<String, dynamic> draftData,
  }) async {
    lastDraftData = draftData;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> submitCoachApplication({
    required CoachProfileModel profile,
    required CoachApplicationModel application,
  }) async => const Right(null);
  @override
  Future<void> clearDraftApplication() async {}
}

void main() {
  late _FakeCoachSetupRepo repo;
  late CoachSetupCubit cubit;

  setUp(() {
    repo = _FakeCoachSetupRepo();
    cubit = CoachSetupCubit(repository: repo);
  });

  tearDown(() => cubit.close());

  group('CoachSetupCubit Sport Locations Tests', () {
    test(
      'toggling sport automatically creates and removes SportLocationModel template',
      () {
        expect(cubit.sportLocations, isEmpty);

        cubit.toggleSport('Tennis');
        expect(cubit.selectedSports, contains('Tennis'));
        expect(cubit.sportLocations.length, 1);
        expect(cubit.sportLocations.first.sport, 'Tennis');
        expect(cubit.sportLocations.first.isValid, isFalse);

        cubit.toggleSport('Tennis');
        expect(cubit.selectedSports, isNot(contains('Tennis')));
        expect(cubit.sportLocations, isEmpty);
      },
    );

    test('addSportLocation and removeSportLocation update venues properly', () {
      cubit.toggleSport('Football');
      cubit.addSportLocation('Football', 'Al Ahly Club');
      cubit.addSportLocation('Football', 'Zamalek Club');

      expect(cubit.sportLocations.first.locations, [
        'Al Ahly Club',
        'Zamalek Club',
      ]);
      expect(cubit.sportLocations.first.isValid, isTrue);

      cubit.removeSportLocation('Football', 0);
      expect(cubit.sportLocations.first.locations, ['Zamalek Club']);
    });

    test('toggleSportOnline updates online delivery capability', () {
      cubit.toggleSport('Fitness');
      expect(cubit.sportLocations.first.isOnline, isFalse);

      cubit.toggleSportOnline('Fitness', true);
      expect(cubit.sportLocations.first.isOnline, isTrue);
      expect(cubit.sportLocations.first.isValid, isTrue);

      cubit.toggleSportOnline('Fitness', false);
      expect(cubit.sportLocations.first.isOnline, isFalse);
      expect(cubit.sportLocations.first.isValid, isFalse);
    });

    test(
      'validation Step 1 fails with sport_locations_required when a sport has no locations or online mode',
      () {
        cubit.currentStep = 1;
        cubit.toggleSport('Basketball');
        expect(cubit.validateStep(1), isFalse);

        final err = CoachSetupValidator.validateStep(
          step: 1,
          photoUrl: 'url',
          name: 'Coach',
          country: 'Egypt',
          city: 'Cairo',
          bio: 'Valid bio that is long enough for tests',
          selectedLanguages: ['Arabic'],
          selectedSports: ['Basketball'],
          sportLocations: cubit.sportLocations,
          availabilitySummary: 'Daily',
          identityDocumentUrl: 'doc',
          certificateUrls: ['cert'],
        );
        expect(err, 'sport_locations_required');

        cubit.toggleSportOnline('Basketball', true);
        expect(cubit.validateStep(1), isTrue);
      },
    );
  });
}
