import 'package:dartz/dartz.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../auth/core/data/data_source/auth_local_data_source.dart';
import '../data_source/trainee_setup_local_data_source.dart';
import '../data_source/trainee_setup_remote_data_source.dart';
import '../models/trainee_profile_model.dart';

class TraineeSetupRepo {
  final TraineeSetupRemoteDataSource remoteDataSource;
  final TraineeSetupLocalDataSource localDataSource;
  final AuthService authService;
  final AuthLocalDataSource authLocalDataSource;

  TraineeSetupRepo({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authService,
    required this.authLocalDataSource,
  });

  Future<Either<String, void>> saveTraineeProfile(
    TraineeProfileModel profile,
  ) async {
    try {
      final cachedUser = await authLocalDataSource.getUser();
      final firebaseUser = authService.currentUser?.uid;
      final uid = firebaseUser ?? cachedUser?.uid;

      if (uid == null) {
        return const Left('User session not found. Please log in again.');
      }

      final resolvedName = profile.name.trim().isNotEmpty
          ? profile.name.trim()
          : (cachedUser?.name ?? authService.currentUser?.displayName ?? '');

      final resolvedEmail = profile.email.trim().isNotEmpty
          ? profile.email.trim()
          : (cachedUser?.email ?? authService.currentUser?.email ?? '');

      final updatedProfile = profile.copyWith(
        uid: uid,
        name: resolvedName,
        email: resolvedEmail,
      );

      // 1. Save profile to Firestore trainee_profiles collection
      await remoteDataSource.saveTraineeProfile(updatedProfile);

      // 2. Save profile to local Hive cache
      await localDataSource.saveCachedProfile(updatedProfile);

      // 3. Keep base user document in users collection consistent
      await remoteDataSource.updateUserProfile(
        uid: uid,
        name: resolvedName,
        role: 'trainee',
      );

      // 4. Update auth user in local box
      if (cachedUser != null) {
        await authLocalDataSource.saveUser(
          user: cachedUser.copyWith(
            name: resolvedName.isNotEmpty ? resolvedName : cachedUser.name,
            role: 'trainee',
          ),
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<TraineeProfileModel?> getCachedTraineeProfile() async {
    try {
      return await localDataSource.getCachedProfile();
    } catch (_) {
      return null;
    }
  }

  Future<TraineeProfileModel?> getTraineeProfile({
    String? targetUid,
    bool forceRefresh = false,
  }) async {
    try {
      final uid = targetUid ??
          authService.currentUser?.uid ??
          (await authLocalDataSource.getUser())?.uid;
      if (uid == null) return null;

      // 1. Return from local cache first if fresh data is not explicitly requested
      if (!forceRefresh) {
        final cached = await localDataSource.getCachedProfile();
        if (cached != null) return cached;
      }

      // 2. Fetch from Firestore trainee_profiles collection
      final remote = await remoteDataSource.getTraineeProfile(uid);

      // 3. Keep local cache updated automatically
      if (remote != null) {
        await localDataSource.saveCachedProfile(remote);
      }

      return remote;
    } catch (_) {
      return null;
    }
  }
}
