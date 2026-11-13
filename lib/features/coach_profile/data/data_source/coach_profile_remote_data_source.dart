import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../../core/services/storage_service/storage_service.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

class CoachProfileRemoteDataSource {
  final FirestoreService firestoreService;
  final StorageService storageService;

  CoachProfileRemoteDataSource({
    required this.firestoreService,
    required this.storageService,
  });

  Future<CoachProfileModel?> getCoachProfile(String uid) async {
    LoggerService.debug(
      'Fetching coach profile doc for $uid',
      tag: 'CoachProfileRemote',
    );
    final doc = await firestoreService.getDoc(
      collection: AppConstants.coachProfilesCollection,
      docId: uid,
    );
    if (doc.exists && doc.data() != null) {
      return CoachProfileModel.fromJson(doc.data()!, uid: doc.id);
    }
    return null;
  }

  Future<void> updateCoachProfile(CoachProfileModel profile) async {
    LoggerService.info(
      'Updating coach profile in Firestore for ${profile.uid}',
      tag: 'CoachProfileRemote',
    );
    await firestoreService.setData(
      collection: AppConstants.coachProfilesCollection,
      docId: profile.uid,
      data: profile.toFirestoreMap(),
      merge: true,
    );
  }

  Future<void> updatePricing({
    required String uid,
    required double sessionPriceUSD,
    required double monthlyPriceUSD,
  }) async {
    LoggerService.info(
      'Updating pricing in Firestore for $uid',
      tag: 'CoachProfileRemote',
    );
    await firestoreService.setData(
      collection: AppConstants.coachProfilesCollection,
      docId: uid,
      data: {
        'sessionPriceUSD': sessionPriceUSD,
        'monthlyPriceUSD': monthlyPriceUSD,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      merge: true,
    );
  }

  Future<String> uploadAvatar({
    required File imageFile,
    required String uid,
  }) async {
    LoggerService.info(
      'Uploading avatar to Storage for $uid',
      tag: 'CoachProfileRemote',
    );
    return await storageService.uploadFile(
      file: imageFile,
      storagePath: 'coach_avatars/$uid.jpg',
      contentType: 'image/jpeg',
    );
  }

  Future<void> updateUserName({
    required String uid,
    required String name,
  }) async {
    await firestoreService.setData(
      collection: AppConstants.usersCollection,
      docId: uid,
      data: {
        'name': name,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      merge: true,
    );
  }
}

