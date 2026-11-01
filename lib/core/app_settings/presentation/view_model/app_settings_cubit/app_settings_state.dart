import 'package:flutter/material.dart';

class AppSettingsState {
  final Locale locale;
  final bool notificationsEnabled;

  const AppSettingsState({
    this.locale = const Locale('en'),
    this.notificationsEnabled = true,
  });

  AppSettingsState copyWith({Locale? locale, bool? notificationsEnabled}) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
