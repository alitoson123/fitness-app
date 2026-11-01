import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/coach_profile/data/repos/coach_profile_repo.dart';
import 'package:fitness_app/features/coach_profile/presentation/view_model/coach_profile_cubit/coach_profile_cubit.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCoachProfileRepo implements CoachProfileRepo {
  bool shouldFail = false;
  String failureMessage = 'Operation failed';
  CoachProfileModel? profile;
  CoachProfileModel? updatedProfilePassed;
  double? updatedSessionPrice;
  double? updatedMonthlyPrice;
  String avatarDownloadUrl = 'https://example.com/avatar.jpg';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<Failure, CoachProfileModel>> getCoachProfile({
    bool forceRefresh = false,
  }) async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage: failureMessage));
    }
    return Right(profile ?? const CoachProfileModel(uid: 'coach-123'));
  }

  @override
  Future<Either<Failure, CoachProfileModel>> updateCoachProfile(
    CoachProfileModel profile,
  ) async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage: failureMessage));
    }
    updatedProfilePassed = profile;
    this.profile = profile;
    return Right(profile);
  }

  @override
  Future<Either<Failure, CoachProfileModel>> updatePricing({
    required String uid,
    required double sessionPriceUSD,
    required double monthlyPriceUSD,
  }) async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage: failureMessage));
    }
    updatedSessionPrice = sessionPriceUSD;
    updatedMonthlyPrice = monthlyPriceUSD;
    final updated = (profile ?? CoachProfileModel(uid: uid)).copyWith(
      sessionPriceUSD: sessionPriceUSD,
      monthlyPriceUSD: monthlyPriceUSD,
    );
    profile = updated;
    return Right(updated);
  }

  @override
  Future<Either<Failure, String>> uploadAvatar({
    required File imageFile,
    required String uid,
  }) async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage: failureMessage));
    }
    return Right(avatarDownloadUrl);
  }
}

void main() {
  group('CoachProfileCubit Tests', () {
    late FakeCoachProfileRepo fakeRepo;
    late CoachProfileCubit cubit;

    final initialProfile = const CoachProfileModel(
      uid: 'coach-123',
      name: 'Captain Tsubasa',
      bio: 'Pro Football Coach',
      sessionPriceUSD: 50.0,
      monthlyPriceUSD: 200.0,
      sports: ['Football'],
      specialties: ['Agility', 'Shooting'],
      yearsOfExperience: 8,
      verificationStatus: 'approved',
    );

    setUp(() {
      fakeRepo = FakeCoachProfileRepo()..profile = initialProfile;
      cubit = CoachProfileCubit(repository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has no profile and not loading', () {
      expect(cubit.state.profile, isNull);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isSaving, isFalse);
      expect(cubit.state.errorMessage, isNull);
    });

    test('loadProfile emits success state with profile', () async {
      await cubit.loadProfile();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.profile?.name, equals('Captain Tsubasa'));
      expect(cubit.state.profile?.sessionPriceUSD, equals(50.0));
      expect(cubit.state.errorMessage, isNull);
    });

    test('loadProfile emits error state when repository fails', () async {
      fakeRepo
        ..shouldFail = true
        ..failureMessage = 'Profile not found';

      await cubit.loadProfile();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.profile, isNull);
      expect(cubit.state.errorMessage, equals('Profile not found'));
    });

    test('updateProfile updates profile and emits successMessage', () async {
      await cubit.loadProfile();

      final updated = cubit.state.profile!.copyWith(
        name: 'Coach Genzo',
        sessionPriceUSD: 65.0,
        monthlyPriceUSD: 260.0,
      );

      await cubit.updateProfile(updated);

      expect(cubit.state.isSaving, isFalse);
      expect(cubit.state.profile?.name, equals('Coach Genzo'));
      expect(cubit.state.profile?.sessionPriceUSD, equals(65.0));
      expect(cubit.state.successMessage, equals('profile_updated'));
      expect(fakeRepo.updatedProfilePassed?.name, equals('Coach Genzo'));
    });

    test('updatePricing updates USD pricing directly', () async {
      await cubit.loadProfile();

      await cubit.updatePricing(
        sessionPriceUSD: 80.0,
        monthlyPriceUSD: 300.0,
      );

      expect(cubit.state.isSaving, isFalse);
      expect(cubit.state.profile?.sessionPriceUSD, equals(80.0));
      expect(cubit.state.profile?.monthlyPriceUSD, equals(300.0));
      expect(cubit.state.successMessage, equals('pricing_updated'));
      expect(fakeRepo.updatedSessionPrice, equals(80.0));
      expect(fakeRepo.updatedMonthlyPrice, equals(300.0));
    });

    test('clearMessages resets error and success messages', () async {
      await cubit.loadProfile();
      await cubit.updatePricing(sessionPriceUSD: 70.0, monthlyPriceUSD: 280.0);
      expect(cubit.state.successMessage, isNotNull);

      cubit.clearMessages();
      expect(cubit.state.successMessage, isNull);
      expect(cubit.state.errorMessage, isNull);
    });
  });
}

