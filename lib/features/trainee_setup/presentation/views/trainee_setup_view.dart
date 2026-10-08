import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/presentation/helpers/coach_setup_localization_helper.dart';
import '../view_model/trainee_setup_cubit/trainee_setup_cubit.dart';
import '../view_model/trainee_setup_cubit/trainee_setup_states.dart';
import '../widgets/setup_action_buttons.dart';
import '../widgets/setup_step_indicators.dart';
import '../widgets/step_goals_widget.dart';
import '../widgets/step_level_widget.dart';
import '../widgets/step_profile_widget.dart';
import '../widgets/step_sports_widget.dart';
import '../widgets/trainee_setup_header.dart';

class TraineeSetupView extends StatelessWidget {
  const TraineeSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TraineeSetupCubit>()..loadInitialData(),
      child: const _TraineeSetupContent(),
    );
  }
}

class _TraineeSetupContent extends StatelessWidget {
  const _TraineeSetupContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TraineeSetupCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.r),
          onPressed: () {
            if (cubit.currentStep > 0) {
              cubit.previousStep();
            } else {
              context.go(AppRoutes.chooseRole);
            }
          },
        ),
      ),
      body: BlocConsumer<TraineeSetupCubit, TraineeSetupState>(
        listener: (context, state) {
          if (state is TraineeSetupSuccessState) {
            Message.showSuccess(context, S.of(context).allSetTitle);
            context.go(AppRoutes.traineeSuccess);
          } else if (state is TraineeSetupErrorState) {
            Message.showError(context, state.errorMessage);
          } else if (state is TraineeSetupFormUpdatedState &&
              state.validationError != null) {
            Message.showError(
              context,
              CoachSetupLocalizationHelper.getLocalizedValidationError(
                context,
                state.validationError!,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is TraineeSetupLoadingState;
          final currentStep = cubit.currentStep;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TraineeSetupHeader(currentStep: currentStep, totalSteps: 4),
                  SizedBox(height: 12.h),
                  SetupStepIndicators(
                    currentStep: currentStep,
                    totalSteps: 4,
                    onStepTapped: cubit.goToStep,
                  ),
                  SizedBox(height: 16.h),
                  Expanded(child: _buildCurrentStepWidget(cubit, currentStep)),
                  SetupActionButtons(
                    currentStep: currentStep,
                    totalSteps: 4,
                    isLoading: isLoading,
                    onContinue: cubit.nextStep,
                    onBack: cubit.previousStep,
                    onSkip: cubit.skipStep,
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStepWidget(TraineeSetupCubit cubit, int step) {
    switch (step) {
      case 0:
        return StepProfileWidget(cubit: cubit);
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
