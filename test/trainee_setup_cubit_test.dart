import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';
import 'package:fitness_app/features/trainee_setup/data/repos/trainee_setup_repo.dart';
import 'package:fitness_app/features/trainee_setup/presentation/view_model/trainee_setup_cubit/trainee_setup_cubit.dart';
import 'package:fitness_app/features/trainee_setup/presentation/view_model/trainee_setup_cubit/trainee_setup_states.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTraineeSetupRepo implements TraineeSetupRepo {
  bool saveCalled = false;
  TraineeProfileModel? savedProfile;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<String, void>> saveTraineeProfile(TraineeProfileModel profile) async {
    saveCalled = true;
    savedProfile = profile;
    return const Right(null);
  }

  @override
  Future<TraineeProfileModel?> getCachedTraineeProfile() async => null;

  @override
  Future<TraineeProfileModel?> getTraineeProfile({
    String? targetUid,
    bool forceRefresh = false,
  }) async => null;
}

void main() {
  group('TraineeSetupCubit Tests', () {
    late FakeTraineeSetupRepo fakeRepo;
    late TraineeSetupCubit cubit;

    setUp(() {
      fakeRepo = FakeTraineeSetupRepo();
      cubit = TraineeSetupCubit(repository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state contains step 0 and empty form defaults', () {
      expect(cubit.currentStep, 0);
      expect(cubit.gender, '');
      expect(cubit.selectedLevel, '');
      expect(cubit.selectedGoal, '');
      expect(cubit.state, isA<TraineeSetupFormUpdatedState>());
    });

    test('validation prevents advancing step 0 when required fields are empty', () {
      cubit.nextStep();
      expect(cubit.currentStep, 0);
      expect(cubit.state, isA<TraineeSetupFormUpdatedState>());
      final state = cubit.state as TraineeSetupFormUpdatedState;
      expect(state.validationError, isNotNull);
    });

    test('nextStep advances step when valid and previousStep goes back', () {
      cubit.setName('Alex');
      cubit.setCountry('USA');
      cubit.setCity('New York');
      cubit.setAge(25);
      cubit.setGender('male');

      cubit.nextStep();
      expect(cubit.currentStep, 1);
      cubit.nextStep();
      expect(cubit.currentStep, 2);
      cubit.previousStep();
      expect(cubit.currentStep, 1);
    });

    test('toggleSport adds and removes sport properly', () {
      expect(cubit.selectedSports.contains('football'), false);
      cubit.toggleSport('football');
      expect(cubit.selectedSports.contains('football'), true);
      cubit.toggleSport('football');
      expect(cubit.selectedSports.contains('football'), false);
    });

    test('submitProfile calls repo and emits success state', () async {
      await cubit.submitProfile();
      expect(fakeRepo.saveCalled, true);
      expect(cubit.state, isA<TraineeSetupSuccessState>());
    });
  });
}
