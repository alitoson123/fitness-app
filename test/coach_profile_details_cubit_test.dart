import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/features/coach_profile_details/data/repos/coach_profile_details_repo.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/view_model/coach_profile_details_cubit/coach_profile_details_cubit.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/view_model/coach_profile_details_cubit/coach_profile_details_states.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCoachProfileDetailsRepo implements CoachProfileDetailsRepo {
  bool shouldFail = false;
  CoachProfileModel? mockProfile;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<Failure, CoachProfileModel>> getCoachDetails({
    required String coachUid,
    CoachProfileModel? initialCoach,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      return Left(ServerFailure(errorMessage: 'Network exception occurred'));
    }
    return Right(mockProfile ?? initialCoach ?? CoachProfileModel(uid: coachUid));
  }
}

void main() {
  group('CoachProfileDetailsCubit Tests', () {
    late FakeCoachProfileDetailsRepo fakeRepo;
    late CoachProfileDetailsCubit cubit;

    final testCoach = CoachProfileModel(
      uid: 'coach-123',
      name: 'Captain Tamer',
      bio: 'Professional certified fitness trainer',
      sports: const ['Gym', 'Boxing'],
      sessionPrice: 150.0,
      currency: 'SAR',
      yearsOfExperience: 6,
      weeklyAvailability: [
        const DayAvailability(day: DayOfWeek.saturday, isAvailable: true),
      ],
      certificateUrls: const ['https://example.com/cert1.png'],
    );

    setUp(() {
      fakeRepo = FakeCoachProfileDetailsRepo()..mockProfile = testCoach;
      cubit = CoachProfileDetailsCubit(repository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state is CoachProfileDetailsInitial', () {
      expect(cubit.state, isA<CoachProfileDetailsInitial>());
    });

    test('loadCoachDetails with initialCoach emits Loaded immediately and then with complete data', () async {
      final states = <CoachProfileDetailsState>[];
      cubit.stream.listen(states.add);

      await cubit.loadCoachDetails(
        coachUid: 'coach-123',
        initialCoach: testCoach,
      );

      expect(states.length, greaterThanOrEqualTo(1));
      expect(states.first, isA<CoachProfileDetailsLoaded>());
      final loaded = states.last as CoachProfileDetailsLoaded;
      expect(loaded.coach.name, equals('Captain Tamer'));
      expect(loaded.hasCertificates, isTrue);
      expect(loaded.hasSchedule, isTrue);
    });

    test('loadCoachDetails without initialCoach emits Loading then Loaded', () async {
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CoachProfileDetailsLoading>(),
          isA<CoachProfileDetailsLoaded>(),
        ]),
      );

      cubit.loadCoachDetails(coachUid: 'coach-123');

      await expectation;
      final loaded = cubit.state as CoachProfileDetailsLoaded;
      expect(loaded.coach.uid, equals('coach-123'));
    });

    test('loadCoachDetails failure emits CoachProfileDetailsError when no initialCoach', () async {
      fakeRepo.shouldFail = true;
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CoachProfileDetailsLoading>(),
          isA<CoachProfileDetailsError>(),
        ]),
      );

      cubit.loadCoachDetails(coachUid: 'coach-123');

      await expectation;
      final errorState = cubit.state as CoachProfileDetailsError;
      expect(errorState.errorMessage, contains('Network exception'));
    });

    test('refresh updates state successfully', () async {
      await cubit.loadCoachDetails(
        coachUid: 'coach-123',
        initialCoach: testCoach,
      );
      expect(cubit.state, isA<CoachProfileDetailsLoaded>());

      await cubit.refresh('coach-123');
      expect(cubit.state, isA<CoachProfileDetailsLoaded>());
    });
  });
}
