import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/auth/core/data/data_source/auth_local_data_source.dart';
import '../data_source/coach_setup_local_data_source.dart';
import '../data_source/coach_setup_remote_data_source.dart';
import '../models/coach_application_model.dart';
import '../models/coach_profile_model.dart';
import '../../domain/repo/coach_setup_repo.dart';

class CoachSetupRepoImpl implements CoachSetupRepo {
  final CoachSetupRemoteDataSource remoteDataSource;
  final CoachSetupLocalDataSource localDataSource;
  final AuthService authService;
  final AuthLocalDataSource authLocalDataSource;

  CoachSetupRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authService,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> submitCoachApplication({
    required CoachProfileModel profile,
    required CoachApplicationModel application,
  }) async {
    try {
      final user = authService.currentUser;
      final cachedUser = await authLocalDataSource.getUser();
      final uid = user?.uid ?? cachedUser?.uid;
      if (uid == null) {
        return Left(ServerFailure(errorMessage: 'Authentication required.'));
      }

      final email = profile.email.trim().isNotEmpty
          ? profile.email.trim()
          : (user?.email ?? cachedUser?.email ?? '');

      final resolvedProfile = profile.copyWith(
        uid: uid,
        email: email,
      );
      final resolvedApplication = application.copyWith(
        coachUid: uid,
        status: 'pending',
      );

      await remoteDataSource.saveCoachProfile(resolvedProfile);
      await remoteDataSource.submitApplication(resolvedApplication);
      await localDataSource.saveCachedProfile(resolvedProfile);
      await localDataSource.clearDraft();

      if (cachedUser != null) {
        await authLocalDataSource.saveUser(user: cachedUser.copyWith(role: 'coach'));
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoachApplicationModel?>> getCoachApplicationStatus() async {
    try {
      final uid = authService.currentUser?.uid ?? (await authLocalDataSource.getUser())?.uid;
      if (uid == null) {
        return Left(ServerFailure(errorMessage: 'Authentication required.'));
      }
      final app = await remoteDataSource.getCoachApplication(uid);
      return Right(app);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoachProfileModel?>> getCoachProfile() async {
    try {
      final uid = authService.currentUser?.uid ?? (await authLocalDataSource.getUser())?.uid;
      if (uid == null) {
        return Left(ServerFailure(errorMessage: 'Authentication required.'));
      }
      final cached = await localDataSource.getCachedProfile();
      if (cached != null) return Right(cached);

      final remote = await remoteDataSource.getCoachProfile(uid);
      if (remote != null) await localDataSource.saveCachedProfile(remote);
      return Right(remote);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDraftApplication({required Map<String, dynamic> draftData}) async {
    try {
      await localDataSource.saveDraft(draftData);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getDraftApplication() async {
    try {
      final draft = await localDataSource.getDraft();
      return Right(draft);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> clearDraftApplication() async {
    await localDataSource.clearDraft();
  }
}
