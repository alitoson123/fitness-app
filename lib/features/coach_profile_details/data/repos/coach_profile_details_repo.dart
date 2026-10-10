import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:fitness_app/features/coach_profile_details/data/data_source/coach_profile_details_remote_data_source.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

class CoachProfileDetailsRepo {
  final CoachProfileDetailsRemoteDataSource remoteDataSource;

  CoachProfileDetailsRepo({required this.remoteDataSource});

  Future<Either<Failure, CoachProfileModel>> getCoachDetails({
    required String coachUid,
    CoachProfileModel? initialCoach,
  }) async {
    try {
      LoggerService.info(
        'Loading full details for coach: $coachUid',
        tag: 'CoachProfileDetailsRepo',
      );

      final remoteProfile = await remoteDataSource.getCoachProfile(coachUid);
      final profile = remoteProfile ?? initialCoach;

      if (profile == null) {
        return Left(
          ServerFailure(
            errorMessage: 'Coach profile not found for ID: $coachUid',
          ),
        );
      }

      var certificates = profile.certificateUrls;
      if (certificates.isEmpty) {
        certificates = await remoteDataSource.getCoachCertificates(coachUid);
      }

      final completeProfile = profile.copyWith(
        certificateUrls: certificates,
      );

      return Right(completeProfile);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to load coach details: $e',
        tag: 'CoachProfileDetailsRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
