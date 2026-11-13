import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/services/Local_service/general_local_service.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final GeneralLocalService generalLocalService;

  AuthLocalDataSource({required this.generalLocalService});

  static bool _isInitialized = false;

  /// Initialize Hive box for UserModel with graceful recovery if disk data is corrupted
  Future<void> initHive() async {
    if (_isInitialized) return;
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    try {
      if (!Hive.isBoxOpen(AppConstants.userBox)) {
        await Hive.openBox(AppConstants.userBox);
      }
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to open user box, resetting corrupted box: $error',
        tag: 'AuthLocalDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      await Hive.deleteBoxFromDisk(AppConstants.userBox);
      await Hive.openBox(AppConstants.userBox);
    }

    _isInitialized = true;
  }

  /// Save current user to local storage
  Future<void> saveUser({required UserModel user}) async {
    await generalLocalService.put<UserModel>(
      AppConstants.userBox,
      AppConstants.currentUserKey,
      user,
    );
  }

  /// Retrieve current user from local storage
  Future<UserModel?> getUser() async {
    try {
      return await generalLocalService.get<UserModel>(
        AppConstants.userBox,
        AppConstants.currentUserKey,
      );
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to read user from local storage: $error',
        tag: 'AuthLocalDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      await deleteUser(AppConstants.userBox);
      return null;
    }
  }

  Future<void> deleteUser(String boxName) async {
    await generalLocalService.clearBox(boxName);
  }

  /// Boxes holding data that belongs to the signed-in account. All of them
  /// must be wiped on sign-out / account switch, otherwise the next account
  /// on this device sees (and writes with) the previous account's data.
  /// App settings (language, theme) are device-level and are kept.
  static const List<String> sessionBoxes = [
    AppConstants.userBox,
    AppConstants.traineeProfileBox,
    AppConstants.coachProfileBox, // also holds the coach sign-up draft
  ];

  /// Clears every account-specific local cache. Each box is cleared
  /// independently so one failure doesn't leave the others behind.
  Future<void> clearSession() async {
    for (final box in sessionBoxes) {
      try {
        await generalLocalService.clearBox(box);
      } catch (error, stackTrace) {
        LoggerService.error(
          'Failed to clear local box $box: $error',
          tag: 'AuthLocalDataSource',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }
}
