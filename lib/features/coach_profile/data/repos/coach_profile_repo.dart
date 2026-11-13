import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_error_messages.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../auth/core/data/data_source/auth_local_data_source.dart';
import '../../../coach_setup/data/data_source/coach_setup_local_data_source.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../data_source/coach_profile_remote_data_source.dart';

class CoachProfileRepo {
  final CoachProfileRemoteDataSource remoteDataSource;
  final CoachSetupLocalDataSource localDataSource;
  final AuthService authService;
  final AuthLocalDataSource authLocalDataSource;

  CoachProfileRepo({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authService,
    required this.authLocalDataSource,
  });

  Future<String?> _resolveUid() async {
    return authService.currentUser?.uid ??
        (await authLocalDataSource.getUser())?.uid;
  }

  /// The server copy first (it may have been changed on another phone or
  /// by an admin); the copy saved on this phone only when offline.
  Future<Either<Failure, CoachProfileModel>> getCoachProfile() async {
    final uid = await _resolveUid();
    if (uid == null) {
      return Left(ServerFailure(errorMessage: AppErrorMessages.unexpected));
    }
    try {
      final profile = await remoteDataSource.getCoachProfile(uid);
      if (profile != null) {
        await localDataSource.saveCachedProfile(profile);
        return Right(profile);
      }
      return Left(ServerFailure(errorMessage: AppErrorMessages.unexpected));
    } catch (e, st) {
      LoggerService.error('Error getting coach profile: $e',
          tag: 'CoachProfileRepo', error: e, stackTrace: st);
      final cached = await localDataSource.getCachedProfile();
      if (cached != null && cached.uid == uid) return Right(cached);
      return Left(ServerFailure(errorMessage: AppErrorMessages.from(e)));
    }
  }

  Future<Either<Failure, CoachProfileModel>> updateCoachProfile(
    CoachProfileModel profile,
  ) async {
    try {
      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
      await remoteDataSource.updateCoachProfile(updatedProfile);
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
      LoggerService.error('Error updating coach profile: $e',
          tag: 'CoachProfileRepo', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: AppErrorMessages.from(e)));
    }
  }

  Future<Either<Failure, CoachProfileModel>> updatePricing({
    required String uid,
    required double sessionPriceUSD,
    required double monthlyPriceUSD,
  }) async {
    try {
      await remoteDataSource.updatePricing(
        uid: uid,
        sessionPriceUSD: sessionPriceUSD,
        monthlyPriceUSD: monthlyPriceUSD,
      );

      final cached = await localDataSource.getCachedProfile();
      final updated = (cached ?? CoachProfileModel(uid: uid)).copyWith(
        sessionPriceUSD: sessionPriceUSD,
        monthlyPriceUSD: monthlyPriceUSD,
        updatedAt: DateTime.now(),
      );
      await localDataSource.saveCachedProfile(updated);
      return Right(updated);
    } catch (e, st) {
      LoggerService.error('Error updating pricing: $e',
          tag: 'CoachProfileRepo', error: e, stackTrace: st);
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
      LoggerService.error('Error uploading avatar: $e',
          tag: 'CoachProfileRepo', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: AppErrorMessages.from(e)));
    }
  }
}
