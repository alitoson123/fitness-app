import 'package:fitness_app/core/app_settings/data/repos/app_settings_repo.dart';
import 'package:fitness_app/core/app_settings/presentation/view_model/app_settings_cubit/app_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final AppSettingsRepo repository;

  AppSettingsCubit({required this.repository})
      : super(const AppSettingsState());

  Future<void> loadSettings() async {
    final settings = await repository.loadSettings();
    emit(settings);
  }

  Future<void> setLanguage(String languageCode) async {
    await repository.saveLanguage(languageCode);
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  Future<void> toggleNotifications(bool enabled) async {
    await repository.saveNotifications(enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
  }
}
