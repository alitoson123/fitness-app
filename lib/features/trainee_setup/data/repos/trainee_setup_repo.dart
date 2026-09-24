import 'package:dartz/dartz.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/Local_service/general_local_service.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../auth/core/data/data_source/auth_local_data_source.dart';
import '../models/trainee_profile_model.dart';

class TraineeSetupRepo {
  final FirestoreService firestoreService;
  final AuthService authService;
  final AuthLocalDataSource authLocalDataSource;
  final GeneralLocalService generalLocalService;

  TraineeSetupRepo({
    required this.firestoreService,
    required this.authService,
    required this.authLocalDataSource,
    required this.generalLocalService,
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

      final resolvedName =
          cachedUser?.name ?? authService.currentUser?.displayName ?? '';

      final updatedProfile = profile.copyWith(uid: uid, name: resolvedName);

      // 1. Save directly into user document in Firestore
      await firestoreService.setData(
        collection: AppConstants.usersCollection,
        docId: uid,
        data: updatedProfile.toMap(),
        merge: true,
      );

      // 2. Save trainee profile in dedicated Hive Box
      await generalLocalService.put(
        AppConstants.traineeProfileBox,
        AppConstants.currentTraineeProfileKey,
        Map<String, dynamic>.from(updatedProfile.toMap()),
      );

      // 3. Update auth user in user_box
      if (cachedUser != null) {
        await authLocalDataSource.saveUser(
          user: cachedUser.copyWith(role: 'trainee',),
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<TraineeProfileModel?> getCachedTraineeProfile() async {
    try {
      final data = await generalLocalService.get(
        AppConstants.traineeProfileBox,
        AppConstants.currentTraineeProfileKey,
      );
      if (data != null && data is Map) {
        return TraineeProfileModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
