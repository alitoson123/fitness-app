import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_error_messages.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/core/data/data_source/auth_local_data_source.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../trainee_setup/data/data_source/trainee_setup_local_data_source.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';
import '../data_source/trainee_profile_remote_data_source.dart';

class TraineeProfileRepo {
  final TraineeProfileRemoteDataSource remoteDataSource;
  final TraineeSetupLocalDataSource localDataSource;
  final AuthService authService;
  final AuthLocalDataSource authLocalDataSource;

  TraineeProfileRepo({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authService,
    required this.authLocalDataSource,
  });

  Future<String?> _resolveUid() async {
    return authService.currentUser?.uid ??
        (await authLocalDataSource.getUser())?.uid;
  }

  /// The server copy first; this user's copy on the phone only when the
  /// server can't be reached.
  Future<Either<Failure, TraineeProfileModel>> getTraineeProfile() async {
    String? uid;
    try {
      uid = await _resolveUid();
      if (uid == null) {
        return Left(
          ServerFailure(errorMessage: S.current.sessionNotFoundMessage),
        );
      }

      final profile = await remoteDataSource.getTraineeProfile(uid);
      if (profile != null) {
        await localDataSource.saveCachedProfile(profile);
        return Right(profile);
      }
      return Left(ServerFailure(errorMessage: S.current.loadProfileError));
    } catch (e, st) {
      LoggerService.error(
        'Error getting trainee profile: $e',
        tag: 'TraineeProfileRepo',
        error: e,
        stackTrace: st,
      );
      final cached = await _cachedProfileFor(uid);
      if (cached != null) return Right(cached);
      return Left(ServerFailure(errorMessage: AppErrorMessages.from(e)));
    }
  }

  Future<TraineeProfileModel?> _cachedProfileFor(String? uid) async {
    if (uid == null) return null;
    try {
      final cached = await localDataSource.getCachedProfile();
      return cached?.uid == uid ? cached : null;
    } catch (_) {
      return null;
    }
  }

  Future<Either<Failure, TraineeProfileModel>> updateTraineeProfile(
    TraineeProfileModel profile,
  ) async {
    try {
      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
      await remoteDataSource.updateTraineeProfile(updatedProfile);
      await localDataSource.saveCachedProfile(updatedProfile);

      final cachedUser = await authLocalDataSource.getUser();
      if (cachedUser != null) {
        final userUpdated = cachedUser.copyWith(
          name: updatedProfile.name.isNotEmpty
              ? updatedProfile.name
              : cachedUser.name,
        );
        await authLocalDataSource.saveUser(user: userUpdated);
        await remoteDataSource.updateUserName(
          uid: updatedProfile.uid,
          name: userUpdated.name,
        );
      }

      return Right(updatedProfile);
    } catch (e, st) {
      LoggerService.error(
        'Error updating trainee profile: $e',
        tag: 'TraineeProfileRepo',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: AppErrorMessages.from(e)));
    }
  }

  Future<Either<Failure, String>> uploadAvatar({
    required File imageFile,
    required String uid,
  }) async {
    try {
      final downloadUrl = await remoteDataSource.uploadAvatar(
        imageFile: imageFile,
        uid: uid,
      );
      return Right(downloadUrl);
    } catch (e, st) {
      LoggerService.error(
        'Error uploading avatar: $e',
        tag: 'TraineeProfileRepo',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: AppErrorMessages.from(e)));
    }
  }

  Future<Either<Failure, List<BookingModel>>> getTraineeBookings() async {
    try {
      final uid = await _resolveUid();
      if (uid == null) {
        return Left(
          ServerFailure(errorMessage: S.current.sessionNotFoundMessage),
        );
      }
      final bookings = await remoteDataSource.getTraineeBookings(uid);
      return Right(bookings);
    } catch (e, st) {
      LoggerService.error(
        'Error fetching trainee bookings for insights: $e',
        tag: 'TraineeProfileRepo',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: AppErrorMessages.from(e)));
    }
  }
}
