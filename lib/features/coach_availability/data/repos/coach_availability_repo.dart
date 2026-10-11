import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/day_availability.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../../core/widgets/availability_selector/availability_helper.dart';
import '../../../coach_setup/data/data_source/coach_setup_local_data_source.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../data_source/coach_availability_remote_data_source.dart';

class CoachAvailabilityRepo {
  final CoachAvailabilityRemoteDataSource remoteDataSource;
  final CoachSetupLocalDataSource localDataSource;

  CoachAvailabilityRepo({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<Either<Failure, CoachProfileModel>> getCoachProfile(
    String coachUid,
  ) async {
    try {
      LoggerService.info(
        'Fetching coach profile for availability: $coachUid',
        tag: 'CoachAvailabilityRepo',
      );

      final remoteProfile = await remoteDataSource.getCoachProfile(coachUid);
      if (remoteProfile != null) {
        await localDataSource.saveCachedProfile(remoteProfile);
        return Right(remoteProfile);
      }

      final cached = await localDataSource.getCachedProfile();
      if (cached != null) {
        return Right(cached);
      }

      return Left(
        ServerFailure(
          errorMessage: 'Coach profile not found for ID: $coachUid',
        ),
      );
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to fetch coach profile: $e',
        tag: 'CoachAvailabilityRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateCoachAvailability({
    required String coachUid,
    required List<DayAvailability> schedule,
    required int sessionDurationMinutes,
  }) async {
    try {
      LoggerService.info(
        'Updating availability for coach: $coachUid',
        tag: 'CoachAvailabilityRepo',
      );

      await remoteDataSource.updateCoachAvailability(
        coachUid: coachUid,
        schedule: schedule,
        sessionDurationMinutes: sessionDurationMinutes,
      );

      final cached = await localDataSource.getCachedProfile();
      if (cached != null) {
        final activeDays = schedule
            .where((d) => d.isAvailable)
            .map((d) => d.day.name)
            .toList();

        final workingHoursData = <String, dynamic>{
          for (final availableDay in schedule.where((d) => d.isAvailable))
            availableDay.day.name: {
              'fromHour': availableDay.fromTime.hour,
              'fromMinute': availableDay.fromTime.minute,
              'toHour': availableDay.toTime.hour,
              'toMinute': availableDay.toTime.minute,
            },
        };

        final summary = AvailabilityHelper.buildRawSummaryString(schedule);
        final updated = cached.copyWith(
          weeklyAvailability: schedule,
          workingDays: activeDays,
          workingHours: workingHoursData,
          sessionDurationMinutes: sessionDurationMinutes,
          availabilitySummary: summary,
        );
        await localDataSource.saveCachedProfile(updated);
      }

      return const Right(null);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to update coach availability: $e',
        tag: 'CoachAvailabilityRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
