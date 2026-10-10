import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import '../models/coach_application_model.dart';
import '../models/coach_profile_model.dart';

class CoachSetupRemoteDataSource {
  final FirestoreService firestoreService;

  CoachSetupRemoteDataSource({required this.firestoreService});

  Future<void> saveCoachProfile(CoachProfileModel profile) async {
    LoggerService.info(
      'Saving coach profile for ${profile.uid}',
      tag: 'CoachSetup',
    );
    await firestoreService.setData(
      collection: AppConstants.coachProfilesCollection,
      docId: profile.uid,
      data: profile.toMap(),
      merge: true,
    );
  }

  Future<void> submitApplication(CoachApplicationModel application) async {
    LoggerService.info(
      'Submitting application for ${application.coachUid}',
      tag: 'CoachSetup',
    );
    await firestoreService.setData(
      collection: AppConstants.verificationsCollection,
      docId: application.coachUid,
      data: application.toMap(),
      merge: true,
    );
  }

  Future<CoachProfileModel?> getCoachProfile(String uid) async {
    LoggerService.debug('Fetching coach profile for $uid', tag: 'CoachSetup');
    final doc = await firestoreService.getDoc(
      collection: AppConstants.coachProfilesCollection,
      docId: uid,
    );
    if (doc.exists && doc.data() != null) {
      return CoachProfileModel.fromJson(doc.data()!, uid: doc.id);
    }
    return null;
  }

  Future<CoachApplicationModel?> getCoachApplication(String uid) async {
    LoggerService.debug(
      'Fetching coach application for $uid',
      tag: 'CoachSetup',
    );
    final doc = await firestoreService.getDoc(
      collection: AppConstants.verificationsCollection,
      docId: uid,
    );
    if (doc.exists && doc.data() != null) {
      return CoachApplicationModel.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<CoachApplicationModel?> streamCoachApplication(String uid) {
    LoggerService.debug(
      'Streaming coach application for $uid',
      tag: 'CoachSetup',
    );
    return firestoreService
        .streamDoc(collection: AppConstants.verificationsCollection, docId: uid)
        .map((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            return CoachApplicationModel.fromJson(snapshot.data()!);
          }
          return null;
        });
  }
}
