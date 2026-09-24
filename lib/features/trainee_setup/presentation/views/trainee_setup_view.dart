import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../view_model/trainee_setup_cubit/trainee_setup_cubit.dart';
import '../view_model/trainee_setup_cubit/trainee_setup_states.dart';
import '../widgets/setup_action_buttons.dart';
import '../widgets/setup_curved_header.dart';
import '../widgets/step_goals_widget.dart';
import '../widgets/step_level_widget.dart';
import '../widgets/step_profile_widget.dart';
import '../widgets/step_sports_widget.dart';

class TraineeSetupView extends StatelessWidget {
  const TraineeSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TraineeSetupCubit>(),
      child: const _TraineeSetupContent(),
    );
  }
}

class _TraineeSetupContent extends StatelessWidget {
  const _TraineeSetupContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<TraineeSetupCubit>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      body: SafeArea(
        child: BlocConsumer<TraineeSetupCubit, TraineeSetupState>(
          listener: (context, state) {
            if (state is TraineeSetupSuccessState) {
              context.go(AppRoutes.traineeSuccess);
            } else if (state is TraineeSetupErrorState) {
              Message.showError(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            final isLoading = state is TraineeSetupLoadingState;
            final currentStep = cubit.currentStep;

            return Column(
              children: [
                SetupCurvedHeader(
                  currentStep: currentStep,
                  onBack: cubit.previousStep,
                ),
                Expanded(
                  child: _buildCurrentStepWidget(cubit, currentStep),
                ),
                SetupActionButtons(
                  currentStep: currentStep,
                  isLoading: isLoading,
                  onContinue: cubit.nextStep,
                  onSkip: cubit.skipStep,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentStepWidget(TraineeSetupCubit cubit, int step) {
    switch (step) {
      case 0:
        return StepProfileWidget(
          photoUrl: cubit.photoUrl,
          gender: cubit.gender,
          location: cubit.location,
          onPhotoSelected: cubit.setPhotoUrl,
          onGenderChanged: cubit.setGender,
          onLocationChanged: cubit.setLocation,
        );
      case 1:
        return StepSportsWidget(
          selectedSports: cubit.selectedSports,
          onSportToggled: cubit.toggleSport,
        );
      case 2:
        return StepLevelWidget(
          selectedLevel: cubit.selectedLevel,
          onLevelSelected: cubit.setLevel,
        );
      case 3:
      default:
        return StepGoalsWidget(
          selectedGoal: cubit.selectedGoal,
          onGoalSelected: cubit.setGoal,
        );
    }
  }
}
