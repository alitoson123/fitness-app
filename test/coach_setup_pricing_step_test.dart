import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_validator.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockCoachSetupRepo implements CoachSetupRepo {
  Map<String, dynamic>? lastDraftData;

  @override
  Future<Either<Failure, CoachApplicationModel?>> getCoachApplicationStatus() async {
    return const Right(null);
  }

  @override
  Stream<CoachApplicationModel?> streamCoachApplicationStatus() {
    return const Stream.empty();
  }

  @override
  Future<Either<Failure, CoachProfileModel?>> getCoachProfile() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getDraftApplication() async {
    return Right(lastDraftData);
  }

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
  }) async {
    return const Right(null);
  }

  @override
  Future<void> clearDraftApplication() async {}
}

void main() {
  group('CoachSetupValidator Step 2 Pricing Tests', () {
    test('requires positive session price (> 0)', () {
      final err = CoachSetupValidator.validateStep(
        step: 2,
        photoUrl: '',
        name: '',
        country: '',
        city: '',
        bio: '',
        selectedLanguages: [],
        selectedSports: [],
        sessionPriceUSD: 0.0,
        monthlyPriceUSD: 100.0,
        availabilitySummary: '',
        identityDocumentUrl: '',
        certificateUrls: [],
      );
      expect(err, equals('session_rate_required'));
    });

    test('requires positive monthly price (> 0)', () {
      final err = CoachSetupValidator.validateStep(
        step: 2,
        photoUrl: '',
        name: '',
        country: '',
        city: '',
        bio: '',
        selectedLanguages: [],
        selectedSports: [],
        sessionPriceUSD: 40.0,
        monthlyPriceUSD: 0.0,
        availabilitySummary: '',
        identityDocumentUrl: '',
        certificateUrls: [],
      );
      expect(err, equals('monthly_rate_required'));
    });

    test('passes when both session and monthly prices are positive', () {
      final err = CoachSetupValidator.validateStep(
        step: 2,
        photoUrl: '',
        name: '',
        country: '',
        city: '',
        bio: '',
        selectedLanguages: [],
        selectedSports: [],
        sessionPriceUSD: 40.0,
        monthlyPriceUSD: 150.0,
        availabilitySummary: '',
        identityDocumentUrl: '',
        certificateUrls: [],
      );
      expect(err, isNull);
    });
  });

  group('CoachSetupCubit Dual Pricing State Tests', () {
    test('updates session and monthly price in state and draft', () {
      final repo = _MockCoachSetupRepo();
      final cubit = CoachSetupCubit(repository: repo);

      cubit.setSessionPrice(50.0);
      expect(cubit.sessionPriceUSD, equals(50.0));
      expect(cubit.sessionPrice, equals(50.0));
      expect(repo.lastDraftData?['sessionPriceUSD'], equals(50.0));

      cubit.setMonthlyPrice(200.0);
      expect(cubit.monthlyPriceUSD, equals(200.0));
      expect(repo.lastDraftData?['monthlyPriceUSD'], equals(200.0));
      expect(repo.lastDraftData?['currency'], equals('USD'));
    });
  });
}
