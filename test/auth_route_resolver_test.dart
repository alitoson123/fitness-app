import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/navigator/app_routes.dart';
import 'package:fitness_app/core/navigator/auth_route_resolver.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: subtype_of_sealed_class
class _FakeDocSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final bool exists;
  final Map<String, dynamic>? _data;
  _FakeDocSnapshot(this.exists, this._data);

  @override
  Map<String, dynamic>? data() => _data;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFirestoreService implements FirestoreService {
  final Map<String, Map<String, Map<String, dynamic>>> store = {};

  void setDocData(String collection, String docId, Map<String, dynamic>? data) {
    store.putIfAbsent(collection, () => {})[docId] = data ?? {};
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({
    required String collection,
    required String docId,
  }) async {
    final col = store[collection];
    if (col == null || !col.containsKey(docId)) {
      return _FakeDocSnapshot(false, null);
    }
    return _FakeDocSnapshot(true, col[docId]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('AuthRouteResolver Tests', () {
    late FakeFirestoreService fakeFirestore;
    late AuthRouteResolver resolver;

    setUp(() {
      fakeFirestore = FakeFirestoreService();
      resolver = AuthRouteResolver(firestoreService: fakeFirestore);
    });

    test('returns chooseRole when role is empty', () async {
      final route = await resolver.resolveTargetRoute(uid: 'u1', role: '');
      expect(route, AppRoutes.chooseRole);
    });

    test('returns chooseRole when role is unrecognized', () async {
      final route = await resolver.resolveTargetRoute(uid: 'u1', role: 'unknown');
      expect(route, AppRoutes.chooseRole);
    });

    test('returns coachRegistration when coach application does not exist', () async {
      final route = await resolver.resolveTargetRoute(uid: 'coach1', role: 'coach');
      expect(route, AppRoutes.coachRegistration);
    });

    test('returns coachVerificationPending when coach application is pending', () async {
      fakeFirestore.setDocData(
        AppConstants.verificationsCollection,
        'coach1',
        {'status': 'pending'},
      );

      final route = await resolver.resolveTargetRoute(uid: 'coach1', role: 'coach');
      expect(route, AppRoutes.coachVerificationPending);
    });

    test('returns coachVerificationPending when coach application is rejected', () async {
      fakeFirestore.setDocData(
        AppConstants.verificationsCollection,
        'coach1',
        {'status': 'rejected', 'rejectionReason': 'Need clearer ID'},
      );

      final route = await resolver.resolveTargetRoute(uid: 'coach1', role: 'coach');
      expect(route, AppRoutes.coachVerificationPending);
    });

    test('returns coachDashboard when coach application is approved', () async {
      fakeFirestore.setDocData(
        AppConstants.verificationsCollection,
        'coach1',
        {'status': 'approved'},
      );

      final route = await resolver.resolveTargetRoute(uid: 'coach1', role: 'coach');
      expect(route, AppRoutes.coachDashboard);
    });

    test('returns traineeSetup when trainee profile does not exist', () async {
      final route = await resolver.resolveTargetRoute(uid: 'trainee1', role: 'trainee');
      expect(route, AppRoutes.traineeSetup);
    });

    test('returns traineeSetup when trainee profile in collection is incomplete', () async {
      fakeFirestore.setDocData(
        AppConstants.traineeProfilesCollection,
        'trainee1',
        {'isProfileCompleted': false},
      );

      final route = await resolver.resolveTargetRoute(uid: 'trainee1', role: 'trainee');
      expect(route, AppRoutes.traineeSetup);
    });

    test('returns traineeHome when trainee profile in trainee_profiles is completed', () async {
      fakeFirestore.setDocData(
        AppConstants.traineeProfilesCollection,
        'trainee1',
        {'isProfileCompleted': true},
      );

      final route = await resolver.resolveTargetRoute(uid: 'trainee1', role: 'trainee');
      expect(route, AppRoutes.traineeHome);
    });
  });
}
