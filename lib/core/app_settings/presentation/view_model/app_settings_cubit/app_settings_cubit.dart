import 'package:fitness_app/core/app_settings/data/repos/app_settings_repo.dart';
import 'package:fitness_app/core/app_settings/presentation/view_model/app_settings_cubit/app_settings_state.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/core/services/notification_service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final AppSettingsRepo repository;
  final NotificationService? notificationService;
  final AuthService? authService;

  AppSettingsCubit({
    required this.repository,
    this.notificationService,
    this.authService,
  }) : super(const AppSettingsState());

  Future<void> loadSettings() async {
    final settings = await repository.loadSettings();
    notificationService?.updatePreferences(
      languageCode: settings.locale.languageCode,
      notificationsEnabled: settings.notificationsEnabled,
    );
    emit(settings);
    final uid = authService?.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      await notificationService?.syncUserPreferences(
        uid: uid,
        languageCode: settings.locale.languageCode,
        notificationsEnabled: settings.notificationsEnabled,
      );
    }
  }

  Future<void> setLanguage(String languageCode) async {
    await repository.saveLanguage(languageCode);
    notificationService?.updatePreferences(languageCode: languageCode);
    emit(state.copyWith(locale: Locale(languageCode)));
    final uid = authService?.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      await notificationService?.syncUserPreferences(
        uid: uid,
        languageCode: languageCode,
      );
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    await repository.saveNotifications(enabled);
    notificationService?.updatePreferences(notificationsEnabled: enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
    final uid = authService?.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      await notificationService?.syncUserPreferences(
        uid: uid,
        notificationsEnabled: enabled,
      );
    }
  }
}
