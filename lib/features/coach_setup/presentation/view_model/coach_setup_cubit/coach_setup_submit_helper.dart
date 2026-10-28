import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'coach_setup_cubit.dart';
import 'coach_setup_draft_helper.dart';
import 'coach_setup_states.dart';

class CoachSetupSubmitHelper {
  static Future<void> submit({
    required CoachSetupRepo repository,
    required CoachSetupCubit cubit,
    required void Function(CoachSetupState) emit,
  }) async {
    for (int i = 0; i <= 4; i++) {
      if (!cubit.validateStep(i)) {
        cubit.currentStep = i;
        return;
      }
    }
    emit(const CoachSetupLoadingState());
    final profile = CoachSetupDraftHelper.buildProfile(cubit);
    final application = CoachSetupDraftHelper.buildApplication(cubit);
    final result = await repository.submitCoachApplication(
      profile: profile,
      application: application,
    );
    result.fold(
      (failure) =>
          emit(CoachSetupErrorState(errorMessage: failure.errorMessage)),
      (_) => emit(const CoachSetupSuccessState()),
    );
  }

  static Future<bool> loadDraftOrPrevious({
    required CoachSetupRepo repository,
    required CoachSetupCubit cubit,
    required CoachProfileModel? prevProfile,
    required CoachApplicationModel? prevApp,
    required void Function() onLoaded,
  }) async {
    if (prevProfile != null) {
      CoachSetupDraftHelper.applyProfile(cubit, prevProfile, prevApp);
      onLoaded();
      return true;
    }
    final draftRes = await repository.getDraftApplication();
    return draftRes.fold((_) => false, (data) {
      if (data == null) return false;
      CoachSetupDraftHelper.applyDraft(cubit, data);
      onLoaded();
      return true;
    });
  }
}

