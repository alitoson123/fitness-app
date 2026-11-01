import 'package:fitness_app/core/app_settings/data/repos/app_settings_repo.dart';
import 'package:fitness_app/core/app_settings/presentation/view_model/app_settings_cubit/app_settings_cubit.dart';
import 'package:fitness_app/core/app_settings/presentation/view_model/app_settings_cubit/app_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAppSettingsRepo implements AppSettingsRepo {
  AppSettingsState state = const AppSettingsState();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<AppSettingsState> loadSettings() async => state;

  @override
  Future<void> saveLanguage(String languageCode) async {
    state = state.copyWith(locale: Locale(languageCode));
  }

  @override
  Future<void> saveNotifications(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
  }
}

void main() {
  group('AppSettingsCubit Tests', () {
    late FakeAppSettingsRepo fakeRepo;
    late AppSettingsCubit cubit;

    setUp(() {
      fakeRepo = FakeAppSettingsRepo();
      cubit = AppSettingsCubit(repository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('default state has English locale and notifications enabled', () {
      expect(cubit.state.locale.languageCode, equals('en'));
      expect(cubit.state.notificationsEnabled, isTrue);
    });

    test('setLanguage changes locale to Arabic', () async {
      await cubit.setLanguage('ar');

      expect(cubit.state.locale.languageCode, equals('ar'));
      expect(fakeRepo.state.locale.languageCode, equals('ar'));
    });

    test('toggleNotifications updates notifications flag', () async {
      await cubit.toggleNotifications(false);

      expect(cubit.state.notificationsEnabled, isFalse);

      await cubit.toggleNotifications(true);
      expect(cubit.state.notificationsEnabled, isTrue);
    });
  });
}

