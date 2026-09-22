import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/services/Local_service/general_local_service.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final GeneralLocalService generalLocalService;

  AuthLocalDataSource({required this.generalLocalService});

  static bool _isInitialized = false;

  // initialize hive
  Future<void> initHive() async {
    if (_isInitialized) return;
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    await Hive.openBox<UserModel>(AppConstants.userBox);
    _isInitialized = true;
  }

  //  save user
  Future<void> saveUser({required UserModel user}) async {
    await generalLocalService.put<UserModel>(
      AppConstants.userBox,
      AppConstants.currentUserKey,
      user,
    );
  }

  // get user
  Future<UserModel?> getUser() async {
    return await generalLocalService.get<UserModel>(
      AppConstants.userBox,
      AppConstants.currentUserKey,
    );
  }

  // delete user
  Future<void> deleteUser() async {
    await generalLocalService.clearBox<UserModel>(AppConstants.userBox);
  }
}
