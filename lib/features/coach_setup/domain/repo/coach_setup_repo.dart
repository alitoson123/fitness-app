import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import '../../data/models/coach_application_model.dart';
import '../../data/models/coach_profile_model.dart';

abstract class CoachSetupRepo {
  Future<Either<Failure, void>> submitCoachApplication({
    required CoachProfileModel profile,
    required CoachApplicationModel application,
  });

  Future<Either<Failure, CoachApplicationModel?>> getCoachApplicationStatus();

  Future<Either<Failure, CoachProfileModel?>> getCoachProfile();

  Future<Either<Failure, void>> saveDraftApplication({
    required Map<String, dynamic> draftData,
  });

  Future<Either<Failure, Map<String, dynamic>?>> getDraftApplication();

  Future<void> clearDraftApplication();
}
