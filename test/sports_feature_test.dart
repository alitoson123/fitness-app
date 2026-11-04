import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/constant/app_sports.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'package:fitness_app/features/trainee_setup/data/repos/trainee_setup_repo.dart';
import 'package:fitness_app/features/trainee_setup/presentation/view_model/trainee_setup_cubit/trainee_setup_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTraineeRepo implements TraineeSetupRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCoachRepo implements CoachSetupRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<Failure, void>> saveDraftApplication({
    required Map<String, dynamic> draftData,
  }) async =>
      const Right(null);
}

void main() {
  group('AppSports Constants & Top 15 Sports Tests', () {
    test('AppSports has exactly 15 popular sports', () {
      expect(AppSports.popularSports.length, 15);
    });

    test('predefined sports include football, padel, badminton, etc.', () {
      expect(AppSports.isPredefined('football'), isTrue);
      expect(AppSports.isPredefined('padel'), isTrue);
      expect(AppSports.isPredefined('badminton'), isTrue);
      expect(AppSports.isPredefined('table_tennis'), isTrue);
      expect(AppSports.isPredefined('crossfit'), isTrue);
      expect(AppSports.isPredefined('handball'), isTrue);
      expect(AppSports.isPredefined('Gym'), isTrue);
      expect(AppSports.isPredefined('yoga'), isFalse);
      expect(AppSports.isPredefined('Squash'), isFalse);
    });

    test('getEmoji returns correct emoji for sport keys', () {
      expect(AppSports.getEmoji('football'), '⚽');
      expect(AppSports.getEmoji('basketball'), '🏀');
      expect(AppSports.getEmoji('swimming'), '🏊');
      expect(AppSports.getEmoji('tennis'), '🎾');
      expect(AppSports.getEmoji('padel'), '🎾');
      expect(AppSports.getEmoji('badminton'), '🏸');
      expect(AppSports.getEmoji('table_tennis'), '🏓');
      expect(AppSports.getEmoji('crossfit'), '💪');
      expect(AppSports.getEmoji('handball'), '🤾');
      expect(AppSports.getEmoji('Squash'), AppSports.customSportEmoji);
    });
  });

  group('TraineeSetupCubit Custom Sports Tests', () {
    late TraineeSetupCubit cubit;

    setUp(() {
      cubit = TraineeSetupCubit(repository: _FakeTraineeRepo());
    });

    tearDown(() => cubit.close());

    test('addCustomSport adds unique custom sports and removes them', () {
      cubit.addCustomSport('Squash');
      expect(cubit.selectedSports, contains('Squash'));

      cubit.addCustomSport('Squash');
      expect(cubit.selectedSports.length, 1);

      cubit.removeCustomSport('Squash');
      expect(cubit.selectedSports, isNot(contains('Squash')));
    });

    test('toggleSport works case-insensitively', () {
      cubit.toggleSport('football');
      expect(cubit.selectedSports, contains('football'));
      cubit.toggleSport('Football');
      expect(cubit.selectedSports, isNot(contains('football')));
    });
  });

  group('CoachSetupCubit Custom Sports Tests', () {
    late CoachSetupCubit cubit;

    setUp(() {
      cubit = CoachSetupCubit(repository: _FakeCoachRepo());
    });

    tearDown(() => cubit.close());

    test('addCustomSport adds custom sport to coach selected sports', () {
      cubit.addCustomSport('Pilates');
      expect(cubit.selectedSports, contains('Pilates'));

      cubit.removeCustomSport('Pilates');
      expect(cubit.selectedSports, isNot(contains('Pilates')));
    });

    test('toggleSport toggles predefined and custom sports safely', () {
      cubit.toggleSport('padel');
      expect(cubit.selectedSports, contains('padel'));
      cubit.toggleSport('padel');
      expect(cubit.selectedSports, isNot(contains('padel')));
    });
  });
}
