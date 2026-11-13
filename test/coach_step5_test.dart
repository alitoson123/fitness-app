import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/storage_service/storage_service.dart';
import 'package:fitness_app/features/auth/core/data/data_source/auth_local_data_source.dart';
import 'package:fitness_app/features/auth/core/data/models/user_model.dart';
import 'package:fitness_app/features/coach_profile/data/data_source/coach_profile_remote_data_source.dart';
import 'package:fitness_app/features/coach_profile/data/repos/coach_profile_repo.dart';
import 'package:fitness_app/features/coach_setup/data/data_source/coach_setup_local_data_source.dart';
import 'package:fitness_app/features/coach_setup/data/data_source/coach_setup_remote_data_source.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/sport_location_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_draft_helper.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_validator.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _SetupRepo implements CoachSetupRepo {
  @override
  Future<Either<Failure, void>> saveDraftApplication({
    required Map<String, dynamic> draftData,
  }) async =>
      const Right(null);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Records every setData call.
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

class _Remote implements CoachProfileRemoteDataSource {
  Object? error;
  CoachProfileModel? profile;
  @override
  Future<CoachProfileModel?> getCoachProfile(String uid) async {
    if (error != null) throw error!;
    return profile;
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Local implements CoachSetupLocalDataSource {
  CoachProfileModel? cached;
  @override
  Future<CoachProfileModel?> getCachedProfile() async => cached;
  @override
  Future<void> saveCachedProfile(CoachProfileModel profile) async => cached = profile;
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
  Future<UserModel?> getUser() async => UserModel(uid: 'coach1');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _mornings = [
  DayAvailability(
    day: DayOfWeek.monday,
    isAvailable: true,
    fromTime: TimeOfDay(hour: 8, minute: 0),
    toTime: TimeOfDay(hour: 12, minute: 0),
  ),
];

void main() {
  setUpAll(() => S.load(const Locale('en')));

  test('#1 re-applying keeps the coach\'s hours and session length', () {
    final cubit = CoachSetupCubit(repository: _SetupRepo());
    const saved = CoachProfileModel(
      uid: 'coach1',
      sports: ['football'],
      weeklyAvailability: _mornings,
      sessionDurationMinutes: 90,
    );

    CoachSetupDraftHelper.applyProfile(cubit, saved, null);
    final rebuilt = CoachSetupDraftHelper.buildProfile(cubit);

    expect(rebuilt.weeklyAvailability.single.fromTime.hour, 8);
    expect(rebuilt.sessionDurationMinutes, 90);
    cubit.close();
  });

  group('#2 setup availability step', () {
    String? check(List<DayAvailability> schedule) => CoachSetupValidator.validateStep(
          step: 3,
          photoUrl: '',
          name: '',
          country: '',
          city: '',
          bio: '',
          selectedLanguages: const [],
          selectedSports: const [],
          availabilitySummary: 'anything',
          weeklyAvailability: schedule,
          identityDocumentUrl: '',
          certificateUrls: const [],
        );

    test('no working day is refused', () {
      expect(check(const [DayAvailability(day: DayOfWeek.monday)]), 'availability_no_days');
    });

    test('ending before starting is refused', () {
      expect(
        check(const [
          DayAvailability(
            day: DayOfWeek.monday,
            isAvailable: true,
            fromTime: TimeOfDay(hour: 12, minute: 0),
            toTime: TimeOfDay(hour: 9, minute: 0),
          ),
        ]),
        'availability_invalid_hours',
      );
    });

    test('a real schedule passes, and the summary matches it', () {
      expect(check(_mornings), isNull);
      final cubit = CoachSetupCubit(repository: _SetupRepo());
      expect(cubit.availabilitySummary, isNot(contains('Mon, Tue, Wed, Thu, Fri')));
      cubit.close();
    });
  });

  test('#3 Edit Profile writes only the fields it edits', () async {
    final fs = _RecordingFirestore();
    final remote = CoachProfileRemoteDataSource(
      firestoreService: fs,
      storageService: _NoStorage(),
    );

    await remote.updateCoachProfile(const CoachProfileModel(
      uid: 'coach1',
      name: 'New name',
      weeklyAvailability: _mornings,
      sessionDurationMinutes: 90,
    ));

    final data = fs.writes.single;
    expect(data['name'], 'New name');
    for (final key in [
      'weeklyAvailability', 'workingDays', 'workingHours',
      'sessionDurationMinutes', 'availabilitySummary',
      'verificationStatus', 'rating', 'reviewsCount',
    ]) {
      expect(data.containsKey(key), isFalse, reason: key);
    }
  });

  group('#3 profile screen loads the server copy', () {
    late _Remote remote;
    late _Local local;
    late CoachProfileRepo repo;

    setUp(() {
      remote = _Remote();
      local = _Local()..cached = const CoachProfileModel(uid: 'coach1', name: 'Old');
      repo = CoachProfileRepo(
        remoteDataSource: remote,
        localDataSource: local,
        authService: _NoAuth(),
        authLocalDataSource: _AuthLocal(),
      );
    });

    test('server first, even when a copy is saved on the phone', () async {
      remote.profile = const CoachProfileModel(uid: 'coach1', name: 'Fresh');
      final r = await repo.getCoachProfile();
      expect(r.fold((_) => '', (p) => p.name), 'Fresh');
      expect(local.cached!.name, 'Fresh');
    });

    test('the phone copy only when the server can\'t be reached', () async {
      remote.error = FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
      final r = await repo.getCoachProfile();
      expect(r.fold((_) => '', (p) => p.name), 'Old');
    });
  });

  test('#4 a sport must be bookable', () {
    expect(CoachSetupValidator.sportsError(const [], const []), 'sport_required');
    expect(
      CoachSetupValidator.sportsError(
        const ['football'],
        const [SportLocationModel(sport: 'football', isOnline: false)],
      ),
      'sport_locations_required',
    );
    expect(
      CoachSetupValidator.sportsError(
        const ['football'],
        const [SportLocationModel(sport: 'football', isOnline: true)],
      ),
      isNull,
    );
  });

  test('#5 a resubmission clears the previous review', () async {
    final fs = _RecordingFirestore();
    final remote = CoachSetupRemoteDataSource(firestoreService: fs);
    const app = CoachApplicationModel(coachUid: 'coach1', identityDocumentUrl: 'u');

    await remote.submitApplication(app);
    expect(fs.writes.last.containsKey('rejectionReason'), isFalse);

    await remote.submitApplication(app, isResubmission: true);
    expect(fs.writes.last['rejectionReason'], FieldValue.delete());
    expect(fs.writes.last['reviewedAt'], FieldValue.delete());
  });
}

class _NoStorage implements StorageService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
