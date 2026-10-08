import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/Local_service/general_local_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import '../models/coach_profile_model.dart';

class CoachSetupLocalDataSource {
  final GeneralLocalService generalLocalService;

  CoachSetupLocalDataSource({required this.generalLocalService});

  Future<void> saveDraft(Map<String, dynamic> draftData) async {
    LoggerService.debug('Saving coach draft locally', tag: 'CoachSetupLocal');
    await generalLocalService.put(
      AppConstants.coachProfileBox,
      AppConstants.currentCoachDraftKey,
      draftData,
    );
  }

  Future<Map<String, dynamic>?> getDraft() async {
    LoggerService.debug('Retrieving coach draft', tag: 'CoachSetupLocal');
    final data = await generalLocalService.get(
      AppConstants.coachProfileBox,
      AppConstants.currentCoachDraftKey,
    );
    if (data != null && data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  Future<void> clearDraft() async {
    LoggerService.debug('Clearing coach draft', tag: 'CoachSetupLocal');
    await generalLocalService.delete(
      AppConstants.coachProfileBox,
      AppConstants.currentCoachDraftKey,
    );
  }

  Future<void> saveCachedProfile(CoachProfileModel profile) async {
    await generalLocalService.put(
      AppConstants.coachProfileBox,
      AppConstants.currentCoachProfileKey,
      profile.toMap(),
    );
  }

  Future<CoachProfileModel?> getCachedProfile() async {
    final data = await generalLocalService.get(
      AppConstants.coachProfileBox,
      AppConstants.currentCoachProfileKey,
    );
    if (data != null && data is Map) {
      return CoachProfileModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }
}
