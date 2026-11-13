import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../../core/services/storage_service/storage_service.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';

class TraineeProfileRemoteDataSource {
  final FirestoreService firestoreService;
  final StorageService storageService;

  TraineeProfileRemoteDataSource({
    required this.firestoreService,
    required this.storageService,
  });

  Future<TraineeProfileModel?> getTraineeProfile(String uid) async {
    LoggerService.debug(
      'Fetching trainee profile doc for $uid',
      tag: 'TraineeProfileRemote',
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

  /// Writes only what the trainee edits (form fields and photo), so an older
  /// copy on this phone can't overwrite anything else.
  Future<void> updateTraineeProfile(TraineeProfileModel profile) async {
    LoggerService.info(
      'Updating trainee profile in Firestore for ${profile.uid}',
      tag: 'TraineeProfileRemote',
    );
    await firestoreService.setData(
      collection: AppConstants.traineeProfilesCollection,
      docId: profile.uid,
      data: {
        'name': profile.name,
        'country': profile.country,
        'city': profile.city,
        'age': profile.age,
        'gender': profile.gender,
        'sports': profile.sports,
        'level': profile.level,
        'goal': profile.goal,
        if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty)
          'photoUrl': profile.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
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
      tag: 'TraineeProfileRemote',
    );
    return await storageService.uploadFile(
      file: imageFile,
      storagePath: 'trainee_avatars/$uid.jpg',
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
      data: {'name': name},
      merge: true,
    );
  }

  Future<List<BookingModel>> getTraineeBookings(String uid) async {
    LoggerService.debug(
      'Fetching trainee bookings for insights: $uid',
      tag: 'TraineeProfileRemote',
    );
    final snapshot = await firestoreService.getCollection(
      collection: AppConstants.bookingsCollection,
      queryBuilder: (q) => q.where('traineeUid', isEqualTo: uid),
    );
    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data(), id: doc.id))
        .toList();
  }
}
