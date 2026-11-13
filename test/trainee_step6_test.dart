import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/storage_service/storage_service.dart';
import 'package:fitness_app/features/auth/core/data/data_source/auth_local_data_source.dart';
import 'package:fitness_app/features/auth/core/data/models/user_model.dart';
import 'package:fitness_app/features/coach_profile_details/data/data_source/coach_profile_details_remote_data_source.dart';
import 'package:fitness_app/features/coach_profile_details/data/repos/coach_profile_details_repo.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/view_model/coach_profile_details_cubit/coach_profile_details_cubit.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/view_model/coach_profile_details_cubit/coach_profile_details_states.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/trainee_discovery/data/models/discovery_filter_model.dart';
import 'package:fitness_app/features/trainee_profile/data/data_source/trainee_profile_remote_data_source.dart';
import 'package:fitness_app/features/trainee_profile/data/repos/trainee_profile_repo.dart';
import 'package:fitness_app/features/trainee_setup/data/data_source/trainee_setup_local_data_source.dart';
import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _DetailsRemote implements CoachProfileDetailsRemoteDataSource {
  CoachProfileModel? profile;
  @override
  Future<CoachProfileModel?> getCoachProfile(String uid) async => profile;
  @override
  Future<List<String>> getCoachCertificates(String uid) async => const [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TraineeRemote implements TraineeProfileRemoteDataSource {
  Object? error;
  TraineeProfileModel? profile;
  @override
  Future<TraineeProfileModel?> getTraineeProfile(String uid) async {
    if (error != null) throw error!;
    return profile;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TraineeLocal implements TraineeSetupLocalDataSource {
  TraineeProfileModel? cached;
  @override
  Future<TraineeProfileModel?> getCachedProfile() async => cached;
  @override
  Future<void> saveCachedProfile(TraineeProfileModel profile) async =>
      cached = profile;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoAuth implements AuthService {
  @override
  User? get currentUser => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AuthLocal implements AuthLocalDataSource {
  @override
  Future<UserModel?> getUser() async => UserModel(uid: 'trainee1');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingFirestore implements FirestoreService {
  final writes = <Map<String, dynamic>>[];
  @override
  Future<void> setData({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async =>
      writes.add(data);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoStorage implements StorageService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() => S.load(const Locale('en')));

  group('#1 price filter', () {
    const pricey = CoachProfileModel(uid: 'c', sessionPriceUSD: 1500);

    test('a coach above 1000 shows when the price filter is untouched', () {
      expect(const DiscoveryFilterModel().matches(pricey), isTrue);
    });

    test('a lowered top limit still hides more expensive coaches', () {
      expect(const DiscoveryFilterModel(maxPrice: 500).matches(pricey), isFalse);
    });
  });

  group('#2/#4 coach details', () {
    late _DetailsRemote remote;
    late CoachProfileDetailsRepo repo;

    setUp(() {
      remote = _DetailsRemote();
      repo = CoachProfileDetailsRepo(remoteDataSource: remote);
    });

    test('a deleted coach gives a clear, translated message', () async {
      final r = await repo.getCoachDetails(coachUid: 'gone');
      final failure = r.fold((f) => f, (_) => null);
      expect(failure, isA<CoachUnavailableFailure>());
      expect(failure!.errorMessage, S.current.coachNoLongerAvailable);
    });

    test('the old copy from the list is replaced when the coach is gone',
        () async {
      final cubit = CoachProfileDetailsCubit(repository: repo);
      await cubit.loadCoachDetails(
        coachUid: 'gone',
        initialCoach: const CoachProfileModel(
          uid: 'gone',
          verificationStatus: 'approved',
        ),
      );
      expect(cubit.state, isA<CoachProfileDetailsError>());
      await cubit.close();
    });
  });

  group('#3 trainee profile', () {
    late _TraineeRemote remote;
    late _TraineeLocal local;
    late TraineeProfileRepo repo;

    setUp(() {
      remote = _TraineeRemote();
      local = _TraineeLocal()
        ..cached = const TraineeProfileModel(uid: 'trainee1', name: 'Old');
      repo = TraineeProfileRepo(
        remoteDataSource: remote,
        localDataSource: local,
        authService: _NoAuth(),
        authLocalDataSource: _AuthLocal(),
      );
    });

    test('server first, even when a copy is saved on the phone', () async {
      remote.profile = const TraineeProfileModel(uid: 'trainee1', name: 'New');
      final r = await repo.getTraineeProfile();
      expect(r.fold((_) => '', (p) => p.name), 'New');
      expect(local.cached!.name, 'New');
    });

    test('the phone copy only when the server can\'t be reached', () async {
      remote.error =
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
      final r = await repo.getTraineeProfile();
      expect(r.fold((_) => '', (p) => p.name), 'Old');
    });

    test('another account\'s phone copy is never used', () async {
      remote.error =
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
      local.cached = const TraineeProfileModel(uid: 'someone-else');
      final r = await repo.getTraineeProfile();
      expect(
        r.fold((f) => f.errorMessage, (_) => ''),
        S.current.connectionErrorMessage,
      );
    });

    test('saving writes only what the trainee edits', () async {
      final fs = _RecordingFirestore();
      final ds = TraineeProfileRemoteDataSource(
        firestoreService: fs,
        storageService: _NoStorage(),
      );
      await ds.updateTraineeProfile(const TraineeProfileModel(
        uid: 'trainee1',
        name: 'Sara',
        isProfileCompleted: false,
      ));
      final data = fs.writes.single;
      expect(data['name'], 'Sara');
      expect(data['updatedAt'], FieldValue.serverTimestamp());
      for (final key in ['uid', 'role', 'isProfileCompleted', 'phoneNumber']) {
        expect(data.containsKey(key), isFalse, reason: key);
      }
    });
  });
}
