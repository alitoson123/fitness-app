import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

abstract class CoachVerificationStatusState {
  const CoachVerificationStatusState();
}

class CoachVerificationStatusInitialState
    extends CoachVerificationStatusState {
  const CoachVerificationStatusInitialState();
}

class CoachVerificationStatusLoadingState
    extends CoachVerificationStatusState {
  const CoachVerificationStatusLoadingState();
}

class CoachVerificationStatusPendingState
    extends CoachVerificationStatusState {
  final CoachApplicationModel application;
  final CoachProfileModel? profile;

  const CoachVerificationStatusPendingState({
    required this.application,
    this.profile,
  });
}

class CoachVerificationStatusApprovedState
    extends CoachVerificationStatusState {
  final CoachApplicationModel application;
  final CoachProfileModel? profile;

  const CoachVerificationStatusApprovedState({
    required this.application,
    this.profile,
  });
}

class CoachVerificationStatusRejectedState
    extends CoachVerificationStatusState {
  final CoachApplicationModel application;
  final CoachProfileModel? profile;
  final String rejectionReason;

  const CoachVerificationStatusRejectedState({
    required this.application,
    this.profile,
    required this.rejectionReason,
  });
}

class CoachVerificationStatusErrorState
    extends CoachVerificationStatusState {
  final String errorMessage;

  const CoachVerificationStatusErrorState({required this.errorMessage});
}

class CoachVerificationStatusSignedOutState
    extends CoachVerificationStatusState {
  const CoachVerificationStatusSignedOutState();
}

