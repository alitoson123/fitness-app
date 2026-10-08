import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../models/trainee_profile_model.dart';

class TraineeSetupRemoteDataSource {
  final FirestoreService firestoreService;

  TraineeSetupRemoteDataSource({required this.firestoreService});

  Future<void> saveTraineeProfile(TraineeProfileModel profile) async {
    LoggerService.info(
      'Saving trainee profile for ${profile.uid}',
      tag: 'TraineeSetupRemote',
    );
    await firestoreService.setData(
      collection: AppConstants.traineeProfilesCollection,
      docId: profile.uid,
      data: profile.toMap(),
      merge: true,
    );
  }

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    required String role,
  }) async {
    LoggerService.debug(
      'Syncing user document for $uid in users collection',
      tag: 'TraineeSetupRemote',
    );
    await firestoreService.setData(
      collection: AppConstants.usersCollection,
      docId: uid,
      data: {
        'role': role,
        if (name.isNotEmpty) 'name': name,
      },
      merge: true,
    );
  }

  Future<TraineeProfileModel?> getTraineeProfile(String uid) async {
    LoggerService.debug(
      'Fetching trainee profile for $uid',
      tag: 'TraineeSetupRemote',
    );
    final doc = await firestoreService.getDoc(
      collection: AppConstants.traineeProfilesCollection,
      docId: uid,
    );
    if (doc.exists && doc.data() != null) {
      return TraineeProfileModel.fromJson(doc.data()!, uid: doc.id);
    }
    return null;
  }
}
