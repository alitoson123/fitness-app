import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_status_states.dart';

class CoachStatusCubit extends Cubit<CoachStatusState> {
  final CoachSetupRepo repository;
  final AuthService authService;

  CoachStatusCubit({
    required this.repository,
    required this.authService,
  }) : super(const CoachStatusInitialState());

  Future<void> checkStatus() async {
    emit(const CoachStatusLoadingState());
    final appResult = await repository.getCoachApplicationStatus();
    final profileResult = await repository.getCoachProfile();

    final profile = profileResult.fold((_) => null, (p) => p);

    appResult.fold(
      (failure) => emit(CoachStatusErrorState(errorMessage: failure.errorMessage)),
      (application) {
        if (application == null) {
          emit(const CoachStatusErrorState(errorMessage: 'No active application found.'));
          return;
        }
        if (application.isApproved) {
          if (profile != null) {
            emit(CoachStatusApprovedState(profile: profile));
          } else {
            emit(CoachStatusPendingState(application: application, profile: profile));
          }
        } else if (application.isRejected) {
          emit(CoachStatusRejectedState(
            application: application,
            profile: profile,
            rejectionReason: application.rejectionReason ?? 'Application requires review adjustments.',
          ));
        } else {
          emit(CoachStatusPendingState(application: application, profile: profile));
        }
      },
    );
  }

  Future<void> signOut() async {
    await authService.signOut();
    emit(const CoachStatusSignedOutState());
  }
}
