import 'dart:async';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_status_states.dart';

class CoachVerificationStatusCubit
    extends Cubit<CoachVerificationStatusState> {
  final CoachSetupRepo repository;
  final AuthService authService;
  StreamSubscription<CoachApplicationModel?>? _subscription;

  CoachVerificationStatusCubit({
    required this.repository,
    required this.authService,
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
          CoachVerificationStatusErrorState(errorMessage: error.toString()),
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
        const CoachVerificationStatusErrorState(
          errorMessage: 'No active application found.',
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
              'Application requires review adjustments.',
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

  Future<void> signOut() async {
    await authService.signOut();
    emit(const CoachVerificationStatusSignedOutState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

