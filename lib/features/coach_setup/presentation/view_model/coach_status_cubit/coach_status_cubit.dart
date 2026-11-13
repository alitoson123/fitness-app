import 'dart:async';
import 'package:fitness_app/core/errors/app_error_messages.dart';
import 'package:fitness_app/features/auth/core/domain/repo/auth_session_repo.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_status_states.dart';

class CoachVerificationStatusCubit
    extends Cubit<CoachVerificationStatusState> {
  final CoachSetupRepo repository;
  final AuthSessionRepo authSessionRepo;
  StreamSubscription<CoachApplicationModel?>? _subscription;

  CoachVerificationStatusCubit({
    required this.repository,
    required this.authSessionRepo,
  }) : super(const CoachVerificationStatusInitialState());

  void listenToVerificationStatus() {
    emit(const CoachVerificationStatusLoadingState());
    _subscription?.cancel();
    _subscription = repository.streamCoachApplicationStatus().listen(
      (application) async {
        await _processApplication(application);
      },
      onError: (error) {
        emit(
          CoachVerificationStatusErrorState(
            errorMessage: AppErrorMessages.from(error as Object),
          ),
        );
      },
    );
  }

  Future<void> checkStatus() async {
    emit(const CoachVerificationStatusLoadingState());
    final appResult = await repository.getCoachApplicationStatus();

    await appResult.fold(
      (failure) async => emit(
        CoachVerificationStatusErrorState(
          errorMessage: failure.errorMessage,
        ),
      ),
      (application) async => await _processApplication(application),
    );
  }

  Future<void> _processApplication(
    CoachApplicationModel? application,
  ) async {
    if (application == null) {
      emit(
        CoachVerificationStatusErrorState(
          errorMessage: S.current.applicationNotFoundMessage,
        ),
      );
      return;
    }

    final profileResult = await repository.getCoachProfile();
    final profile = profileResult.fold((_) => null, (p) => p);

    if (application.isApproved) {
      emit(
        CoachVerificationStatusApprovedState(
          application: application,
          profile: profile,
        ),
      );
    } else if (application.isRejected) {
      emit(
        CoachVerificationStatusRejectedState(
          application: application,
          profile: profile,
          rejectionReason:
              application.rejectionReason ??
              S.current.rejectionReasonFallback,
        ),
      );
    } else {
      emit(
        CoachVerificationStatusPendingState(
          application: application,
          profile: profile,
        ),
      );
    }
  }

  /// Uses the shared sign-out so the local caches are wiped too (the old
  /// version only signed out of Firebase, leaving the cached user behind).
  Future<void> signOut() async {
    final result = await authSessionRepo.signOut();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        CoachVerificationStatusErrorState(errorMessage: failure.errorMessage),
      ),
      (_) => emit(const CoachVerificationStatusSignedOutState()),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

