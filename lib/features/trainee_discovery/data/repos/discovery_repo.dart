import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../data_source/discovery_remote_data_source.dart';

class DiscoveryRepo {
  final DiscoveryRemoteDataSource remoteDataSource;

  DiscoveryRepo({required this.remoteDataSource});

  Future<Either<Failure, List<CoachProfileModel>>> getApprovedCoaches() async {
    try {
      final coaches = await remoteDataSource.getApprovedCoaches();
      return Right(coaches);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to fetch coaches: $e',
        tag: 'DiscoveryRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
