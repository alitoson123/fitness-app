import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/notification_service/notification_service.dart';
import 'package:fitness_app/features/auth/core/data/data_source/auth_local_data_source.dart';
import 'package:fitness_app/features/auth/core/data/repo_impl/auth_session_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

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
    events.add('auth_delete');
    user = null;
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

void main() {
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
        firestoreService: firestore,
        authLocalDataSource: localDataSource,
        notificationService: notificationService,
      );
    });

    test(
      'signOut detaches FCM token before signing out of FirebaseAuth',
      () async {
        final result = await repo.signOut();

        expect(result.isRight(), isTrue);
        expect(authService.events, ['detach:user_99', 'auth_sign_out']);
        expect(localDataSource.clearedBoxes, [AppConstants.userBox]);
      },
    );

    test(
      'deleteAccount deletes fcm_tokens doc and user collections before auth deletion',
      () async {
        final result = await repo.deleteAccount();

        expect(result.isRight(), isTrue);
        expect(authService.events, ['delete_token_doc:user_99', 'auth_delete']);
        expect(
          firestore.deletedDocs,
          containsAll([
            '${AppConstants.usersCollection}/user_99',
            '${AppConstants.coachProfilesCollection}/user_99',
            '${AppConstants.traineeProfilesCollection}/user_99',
            '${AppConstants.verificationsCollection}/user_99',
          ]),
        );
        expect(
          localDataSource.clearedBoxes,
          containsAll([
            AppConstants.userBox,
            AppConstants.traineeProfileBox,
            AppConstants.coachProfileBox,
          ]),
        );
      },
    );
  });
}
