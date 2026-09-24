import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/Local_service/general_local_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';

class OnboardingLocalDataSource {
  final GeneralLocalService generalLocalService;

  OnboardingLocalDataSource({required this.generalLocalService});

  /// Check if user has already completed or skipped the onboarding flow
  Future<bool> isOnboardingCompleted() async {
    try {
      final completed = await generalLocalService.get<bool>(
        AppConstants.appSettingsBox,
        AppConstants.hasSeenOnboardingKey,
      );
      return completed ?? false;
    } catch (e, stack) {
      LoggerService.error(
        'Failed to read onboarding status: $e',
        tag: 'OnboardingLocalDataSource',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Mark onboarding flow as completed
  Future<void> setOnboardingCompleted() async {
    try {
      await generalLocalService.put<bool>(
        AppConstants.appSettingsBox,
        AppConstants.hasSeenOnboardingKey,
        true,
      );
      LoggerService.info(
        'Onboarding completed status saved',
        tag: 'OnboardingLocalDataSource',
      );
    } catch (e, stack) {
      LoggerService.error(
        'Failed to save onboarding status: $e',
        tag: 'OnboardingLocalDataSource',
        error: e,
        stackTrace: stack,
      );
    }
  }
}
