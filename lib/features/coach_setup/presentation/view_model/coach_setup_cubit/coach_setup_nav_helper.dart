import 'coach_setup_cubit.dart';
import 'coach_setup_validator.dart';

class CoachSetupNavHelper {
  static bool validateStep(CoachSetupCubit cubit, int step) {
    final err = CoachSetupValidator.validateCubit(step, cubit);
    if (err != null) {
      cubit.emitCurrentForm(err);
      return false;
    }
    return true;
  }

  static void nextStep(CoachSetupCubit cubit) {
    if (!validateStep(cubit, cubit.currentStep)) return;
    if (cubit.currentStep < 5) {
      cubit.currentStep++;
      cubit.emitCurrentForm();
    } else {
      cubit.submitApplication();
    }
  }

  static void previousStep(CoachSetupCubit cubit) {
    if (cubit.currentStep > 0) {
      cubit.currentStep--;
      cubit.emitCurrentForm();
    }
  }

  static void goToStep(CoachSetupCubit cubit, int step) {
    if (step >= 0 && step <= 5) {
      cubit.currentStep = step;
      cubit.emitCurrentForm();
    }
  }
}
