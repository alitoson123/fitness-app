import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/app_settings/data/repos/app_settings_repo.dart';
import 'package:fitness_app/core/app_settings/presentation/view_model/app_settings_cubit/app_settings_cubit.dart';
import 'package:fitness_app/core/app_settings/presentation/view_model/app_settings_cubit/app_settings_state.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/notification_service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAppSettingsRepo implements AppSettingsRepo {
  AppSettingsState state = const AppSettingsState();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  Future<AppSettingsState> loadSettings() async => state;
  @override
  Future<void> saveLanguage(String languageCode) async =>
      state = state.copyWith(locale: Locale(languageCode));
  @override
  Future<void> saveNotifications(bool enabled) async =>
      state = state.copyWith(notificationsEnabled: enabled);
}

class _FakeUser implements User {
  @override
  final String uid = 'uid_settings';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthService implements AuthService {
  @override
  User? get currentUser => _FakeUser();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DummyFirestore implements FirestoreService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SpyNotificationService extends NotificationService {
  final List<({String uid, String? lang, bool? enabled})> syncedCalls = [];
  _SpyNotificationService() : super(firestoreService: _DummyFirestore());
  @override
  Future<void> syncUserPreferences({
    required String uid,
    String? languageCode,
    bool? notificationsEnabled,
    String? role,
  }) async {
    updatePreferences(
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
    );
    syncedCalls.add((uid: uid, lang: languageCode, enabled: notificationsEnabled));
  }
}

void main() {
  group('AppSettingsCubit Tests', () {
    late FakeAppSettingsRepo fakeRepo;
    late _SpyNotificationService spyNotificationService;
    late AppSettingsCubit cubit;

    setUp(() {
      fakeRepo = FakeAppSettingsRepo();
      spyNotificationService = _SpyNotificationService();
      cubit = AppSettingsCubit(
        repository: fakeRepo,
        notificationService: spyNotificationService,
        authService: _FakeAuthService(),
      );
    });

    tearDown(() => cubit.close());

    test('default state has English locale and notifications enabled', () {
      expect(cubit.state.locale.languageCode, equals('en'));
      expect(cubit.state.notificationsEnabled, isTrue);
    });

    test('setLanguage changes locale and syncs languageCode to NotificationService', () async {
      await cubit.setLanguage('ar');

      expect(cubit.state.locale.languageCode, equals('ar'));
      expect(fakeRepo.state.locale.languageCode, equals('ar'));
      expect(spyNotificationService.languageCode, equals('ar'));
      expect(
        spyNotificationService.syncedCalls.last,
        (uid: 'uid_settings', lang: 'ar', enabled: null),
      );
    });

    test('toggleNotifications updates flag and syncs to NotificationService', () async {
      await cubit.toggleNotifications(false);
      expect(cubit.state.notificationsEnabled, isFalse);
      expect(spyNotificationService.notificationsEnabled, isFalse);
      expect(
        spyNotificationService.syncedCalls.last,
        (uid: 'uid_settings', lang: null, enabled: false),
      );

      await cubit.toggleNotifications(true);
      expect(cubit.state.notificationsEnabled, isTrue);
      expect(spyNotificationService.notificationsEnabled, isTrue);
    });
  });
}
