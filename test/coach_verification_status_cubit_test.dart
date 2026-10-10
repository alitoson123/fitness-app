import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_status_cubit/coach_status_cubit.dart';
import 'package:fitness_app/features/coach_setup/presentation/view_model/coach_status_cubit/coach_status_states.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCoachSetupRepo implements CoachSetupRepo {
  CoachApplicationModel? mockApp;
  CoachProfileModel? mockProfile;
  final StreamController<CoachApplicationModel?> streamController =
      StreamController<CoachApplicationModel?>.broadcast();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<Failure, CoachApplicationModel?>>
      getCoachApplicationStatus() async {
    return Right(mockApp);
  }

  @override
  Stream<CoachApplicationModel?> streamCoachApplicationStatus() {
    return streamController.stream;
  }

  @override
  Future<Either<Failure, CoachProfileModel?>> getCoachProfile() async {
    return Right(mockProfile);
  }
}

class FakeAuthService implements AuthService {
  bool signOutCalled = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }
}

void main() {
  group('CoachVerificationStatusCubit Tests', () {
    late FakeCoachSetupRepo fakeRepo;
    late FakeAuthService fakeAuthService;
    late CoachVerificationStatusCubit cubit;

    setUp(() {
      fakeRepo = FakeCoachSetupRepo();
      fakeAuthService = FakeAuthService();
      cubit = CoachVerificationStatusCubit(
        repository: fakeRepo,
        authService: fakeAuthService,
      );
    });

    tearDown(() {
      cubit.close();
      fakeRepo.streamController.close();
    });

    test('initial state is CoachVerificationStatusInitialState', () {
      expect(cubit.state, isA<CoachVerificationStatusInitialState>());
    });

    test('checkStatus emits Pending state when application is pending',
        () async {
      fakeRepo.mockApp = const CoachApplicationModel(
        coachUid: 'coach_123',
        status: 'pending',
        identityDocumentUrl: 'https://example.com/id.pdf',
      );

      final expectedStates = [
        isA<CoachVerificationStatusLoadingState>(),
        isA<CoachVerificationStatusPendingState>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));
      await cubit.checkStatus();
    });

    test('checkStatus emits Approved state when application is approved',
        () async {
      fakeRepo.mockApp = const CoachApplicationModel(
        coachUid: 'coach_123',
        status: 'approved',
        identityDocumentUrl: 'https://example.com/id.pdf',
      );

      final expectedStates = [
        isA<CoachVerificationStatusLoadingState>(),
        isA<CoachVerificationStatusApprovedState>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));
      await cubit.checkStatus();
    });

    test(
        'checkStatus emits Rejected state with feedback when application is rejected',
        () async {
      fakeRepo.mockApp = const CoachApplicationModel(
        coachUid: 'coach_123',
        status: 'rejected',
        rejectionReason: 'Certificate unreadable',
        identityDocumentUrl: 'https://example.com/id.pdf',
      );

      final expectedStates = [
        isA<CoachVerificationStatusLoadingState>(),
        isA<CoachVerificationStatusRejectedState>().having(
          (s) => s.rejectionReason,
          'rejectionReason',
          'Certificate unreadable',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));
      await cubit.checkStatus();
    });

    test('listenToVerificationStatus updates state dynamically in real time',
        () async {
      cubit.listenToVerificationStatus();

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CoachVerificationStatusPendingState>(),
          isA<CoachVerificationStatusApprovedState>(),
        ]),
      );

      // Emit pending first
      fakeRepo.streamController.add(
        const CoachApplicationModel(
          coachUid: 'coach_123',
          status: 'pending',
          identityDocumentUrl: 'https://example.com/id.pdf',
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Real-time update to approved
      fakeRepo.streamController.add(
        const CoachApplicationModel(
          coachUid: 'coach_123',
          status: 'approved',
          identityDocumentUrl: 'https://example.com/id.pdf',
        ),
      );
    });

    test('signOut calls AuthService and emits SignedOutState', () async {
      expectLater(
        cubit.stream,
        emits(isA<CoachVerificationStatusSignedOutState>()),
      );

      await cubit.signOut();
      expect(fakeAuthService.signOutCalled, isTrue);
    });
  });
}
