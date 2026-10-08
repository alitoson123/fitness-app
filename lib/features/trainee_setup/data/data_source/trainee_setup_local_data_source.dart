import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/Local_service/general_local_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../models/trainee_profile_model.dart';

class TraineeSetupLocalDataSource {
  final GeneralLocalService generalLocalService;

  TraineeSetupLocalDataSource({required this.generalLocalService});

  Future<void> saveCachedProfile(TraineeProfileModel profile) async {
    LoggerService.debug(
      'Saving cached trainee profile for ${profile.uid}',
      tag: 'TraineeSetupLocal',
    );
    await generalLocalService.put(
      AppConstants.traineeProfileBox,
      AppConstants.currentTraineeProfileKey,
      Map<String, dynamic>.from(profile.toMap()),
    );
  }

  Future<TraineeProfileModel?> getCachedProfile() async {
    LoggerService.debug(
      'Fetching cached trainee profile',
      tag: 'TraineeSetupLocal',
    );
    final data = await generalLocalService.get(
      AppConstants.traineeProfileBox,
      AppConstants.currentTraineeProfileKey,
    );
    if (data != null && data is Map) {
      return TraineeProfileModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> clearCachedProfile() async {
    LoggerService.debug(
      'Clearing cached trainee profile',
      tag: 'TraineeSetupLocal',
    );
    await generalLocalService.delete(
      AppConstants.traineeProfileBox,
      AppConstants.currentTraineeProfileKey,
    );
  }
}
