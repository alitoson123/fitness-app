import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

abstract class CoachStatusState {
  const CoachStatusState();
}

class CoachStatusInitialState extends CoachStatusState {
  const CoachStatusInitialState();
}

class CoachStatusLoadingState extends CoachStatusState {
  const CoachStatusLoadingState();
}

class CoachStatusPendingState extends CoachStatusState {
  final CoachApplicationModel application;
  final CoachProfileModel? profile;

  const CoachStatusPendingState({required this.application, this.profile});
}

class CoachStatusRejectedState extends CoachStatusState {
  final CoachApplicationModel application;
  final CoachProfileModel? profile;
  final String rejectionReason;

  const CoachStatusRejectedState({
    required this.application,
    this.profile,
    required this.rejectionReason,
  });
}

class CoachStatusApprovedState extends CoachStatusState {
  final CoachProfileModel profile;

  const CoachStatusApprovedState({required this.profile});
}

class CoachStatusErrorState extends CoachStatusState {
  final String errorMessage;

  const CoachStatusErrorState({required this.errorMessage});
}

class CoachStatusSignedOutState extends CoachStatusState {
  const CoachStatusSignedOutState();
}
