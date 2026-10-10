import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_parser_helper.dart';

class CoachProfileDetailsRemoteDataSource {
  final FirestoreService firestoreService;

  CoachProfileDetailsRemoteDataSource({required this.firestoreService});

  Future<CoachProfileModel?> getCoachProfile(String uid) async {
    LoggerService.info(
      'Fetching coach profile details for uid: $uid',
      tag: 'CoachProfileDetailsRemoteDataSource',
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

  Future<List<String>> getCoachCertificates(String uid) async {
    try {
      final doc = await firestoreService.getDoc(
        collection: AppConstants.verificationsCollection,
        docId: uid,
      );
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return CoachProfileParserHelper.parseList(data['certificateUrls']);
      }
    } catch (e) {
      LoggerService.warning(
        'Could not fetch verification certificates for $uid: $e',
        tag: 'CoachProfileDetailsRemoteDataSource',
      );
    }
    return const [];
  }
}
