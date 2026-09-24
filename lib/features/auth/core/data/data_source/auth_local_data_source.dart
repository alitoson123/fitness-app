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
        await Hive.openBox<UserModel>(AppConstants.userBox);
      }
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to open user box, resetting corrupted box: $error',
        tag: 'AuthLocalDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      await Hive.deleteBoxFromDisk(AppConstants.userBox);
      await Hive.openBox<UserModel>(AppConstants.userBox);
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
      await deleteUser();
      return null;
    }
  }

  /// Delete user cache
  Future<void> deleteUser() async {
    await generalLocalService.clearBox(AppConstants.userBox);
  }
}
