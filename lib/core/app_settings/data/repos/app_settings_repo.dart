import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/Local_service/general_local_service.dart';
import 'package:fitness_app/core/app_settings/presentation/view_model/app_settings_cubit/app_settings_state.dart';
import 'package:flutter/material.dart';

class AppSettingsRepo {
  final GeneralLocalService generalLocalService;

  static const String _keyLanguage = 'language_code';
  static const String _keyNotifications = 'notifications_enabled';

  AppSettingsRepo({required this.generalLocalService});

  Future<AppSettingsState> loadSettings() async {
    final lang = await generalLocalService.get<String>(
      AppConstants.appSettingsBox,
      _keyLanguage,
    );
    final notifs = await generalLocalService.get<bool>(
      AppConstants.appSettingsBox,
      _keyNotifications,
    );

    final locale = Locale(lang ?? 'en');
    final notificationsEnabled = notifs ?? true;

    return AppSettingsState(
      locale: locale,
      notificationsEnabled: notificationsEnabled,
    );
  }

  Future<void> saveLanguage(String languageCode) async {
    await generalLocalService.put(
      AppConstants.appSettingsBox,
      _keyLanguage,
      languageCode,
    );
  }

  Future<void> saveNotifications(bool enabled) async {
    await generalLocalService.put(
      AppConstants.appSettingsBox,
      _keyNotifications,
      enabled,
    );
  }
}
