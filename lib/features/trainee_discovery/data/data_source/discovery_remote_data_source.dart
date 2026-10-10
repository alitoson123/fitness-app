import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

class DiscoveryRemoteDataSource {
  final FirestoreService firestoreService;

  DiscoveryRemoteDataSource({required this.firestoreService});

  Future<List<CoachProfileModel>> getApprovedCoaches() async {
    LoggerService.info(
      'Fetching approved coach profiles for discovery',
      tag: 'DiscoveryRemoteDataSource',
    );

    final snapshot = await firestoreService.getCollection(
      collection: AppConstants.coachProfilesCollection,
      queryBuilder: (query) =>
          query.where('verificationStatus', isEqualTo: 'approved'),
    );

    final coaches = snapshot.docs
        .map((doc) => CoachProfileModel.fromJson(doc.data(), uid: doc.id))
        .toList();

    LoggerService.debug(
      'Fetched ${coaches.length} approved coaches',
      tag: 'DiscoveryRemoteDataSource',
    );
    return coaches;
  }
}
