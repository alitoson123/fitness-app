import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/notification_service/notification_service.dart';
import 'package:fitness_app/features/auth/core/data/data_source/auth_local_data_source.dart';
import 'package:fitness_app/features/auth/core/data/repo_impl/auth_session_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';


class _FakeUser implements User {
  @override
  final String uid;
  _FakeUser(this.uid);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthService implements AuthService {
  User? user;
  final List<String> events = [];
  FirebaseAuthException? deleteError;
  _FakeAuthService(this.user);
  @override
  User? get currentUser => user;
  @override
  Future<void> signOut() async {
    events.add('auth_sign_out');
    user = null;
  }

  @override
  Future<void> deleteAccount() async {
    if (deleteError != null) throw deleteError!;
    events.add('auth_delete');
    user = null;
  }

  @override
  Future<void> reauthenticate(AuthCredential credential) async {
    events.add('reauth');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirestoreService implements FirestoreService {
  final List<String> deletedDocs = [];
  @override
  Future<void> deleteDoc({
    required String collection,
    required String docId,
  }) async {
    deletedDocs.add('$collection/$docId');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  final List<String> clearedBoxes = [];
  @override
  Future<void> deleteUser(String boxName) async => clearedBoxes.add(boxName);
  @override
  Future<void> clearSession() async =>
      clearedBoxes.addAll(AuthLocalDataSource.sessionBoxes);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SpyNotificationService extends NotificationService {
  final List<String> events;
  _SpyNotificationService(this.events)
    : super(firestoreService: _FakeFirestoreService());
  @override
  Future<void> detachFcmToken(String uid) async => events.add('detach:$uid');
  @override
  Future<void> deleteFcmTokenDoc(String uid) async =>
      events.add('delete_token_doc:$uid');
}

class _ThrowingNotificationService extends NotificationService {
  _ThrowingNotificationService(List<String> _)
    : super(firestoreService: _FakeFirestoreService());
  @override
  Future<void> detachFcmToken(String uid) async =>
      throw Exception('offline');
}

void main() {
  setUpAll(() => S.load(const Locale('en')));

  group('AuthSessionRepoImpl Token Lifecycle Tests (Milestone 11.2)', () {
    late _FakeAuthService authService;
    late _FakeFirestoreService firestore;
    late _FakeAuthLocalDataSource localDataSource;
    late _SpyNotificationService notificationService;
    late AuthSessionRepoImpl repo;

    setUp(() {
      authService = _FakeAuthService(_FakeUser('user_99'));
      firestore = _FakeFirestoreService();
      localDataSource = _FakeAuthLocalDataSource();
      notificationService = _SpyNotificationService(authService.events);
      repo = AuthSessionRepoImpl(
        authService: authService,
        authLocalDataSource: localDataSource,
        notificationService: notificationService,
      );
    });

    test(
      'signOut detaches FCM token, signs out, and wipes every account cache',
      () async {
        final result = await repo.signOut();

        expect(result.isRight(), isTrue);
        expect(authService.events, ['detach:user_99', 'auth_sign_out']);
        expect(localDataSource.clearedBoxes, [
          AppConstants.userBox,
          AppConstants.traineeProfileBox,
          AppConstants.coachProfileBox,
        ]);
      },
    );

    test('signOut still signs out and wipes caches when detach fails', () async {
      final failing = _ThrowingNotificationService(authService.events);
      repo = AuthSessionRepoImpl(
        authService: authService,
        authLocalDataSource: localDataSource,
        notificationService: failing,
      );

      final result = await repo.signOut();

      expect(result.isRight(), isTrue);
      expect(authService.events, ['auth_sign_out']);
      expect(localDataSource.clearedBoxes, AuthLocalDataSource.sessionBoxes);
    });

    test(
      'deleteAccount deletes the login first and leaves data to the server',
      () async {
        final result = await repo.deleteAccount();

        expect(result.isRight(), isTrue);
        expect(authService.events, ['auth_delete']);
        expect(firestore.deletedDocs, isEmpty);
        expect(localDataSource.clearedBoxes, AuthLocalDataSource.sessionBoxes);
      },
    );

    test(
      'deleteAccount asks for re-auth and deletes nothing when sign-in is old',
      () async {
        authService.deleteError =
            FirebaseAuthException(code: 'requires-recent-login');

        final result = await repo.deleteAccount();

        expect(
          result.fold((f) => f, (_) => null),
          isA<ReauthRequiredFailure>(),
        );
        expect(authService.events, isEmpty);
        expect(firestore.deletedDocs, isEmpty);
        expect(localDataSource.clearedBoxes, isEmpty);
      },
    );

    test('reauthenticateAndDelete confirms identity then deletes', () async {
      final result = await repo.reauthenticateAndDelete(
        PhoneAuthProvider.credential(verificationId: 'v', smsCode: '123456'),
      );

      expect(result.isRight(), isTrue);
      expect(authService.events, ['reauth', 'auth_delete']);
    });
  });
}
