import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/coach_application_model.dart';
import '../../data/models/coach_profile_model.dart';
import '../helpers/coach_setup_localization_helper.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';
import '../view_model/coach_setup_cubit/coach_setup_states.dart';
import '../widgets/coach_action_buttons.dart';
import '../widgets/coach_setup_header.dart';
import '../widgets/coach_step_indicators.dart';
import '../widgets/step_availability_widget.dart';
import '../widgets/step_personal_info_widget.dart';
import '../widgets/step_pricing_widget.dart';
import '../widgets/step_professional_info_widget.dart';
import '../widgets/step_review_submit_widget.dart';
import '../widgets/step_verification_docs_widget.dart';

class CoachRegistrationView extends StatelessWidget {
  final (CoachProfileModel?, CoachApplicationModel?)? initialData;

  const CoachRegistrationView({super.key, this.initialData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CoachSetupCubit>()
        ..loadDraftOrPrevious(initialData?.$1, initialData?.$2),
      child: const _CoachRegistrationBody(),
    );
  }
}

class _CoachRegistrationBody extends StatelessWidget {
  const _CoachRegistrationBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.r),
          onPressed: () {
            final cubit = context.read<CoachSetupCubit>();
            if (cubit.currentStep > 0) {
              cubit.previousStep();
            } else {
              context.go(AppRoutes.chooseRole);
            }
          },
        ),
      ),
      body: BlocConsumer<CoachSetupCubit, CoachSetupState>(
        listener: (context, state) {
          if (state is CoachSetupSuccessState) {
            Message.showSuccess(
              context,
              S.of(context).applicationSubmittedSuccess,
            );
            context.go(AppRoutes.coachVerificationPending);
          } else if (state is CoachSetupErrorState) {
            Message.showError(context, state.errorMessage);
          } else if (state is CoachSetupFormUpdatedState &&
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
          final cubit = context.read<CoachSetupCubit>();
          final isLoading = state is CoachSetupLoadingState;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoachSetupHeader(
                    currentStep: cubit.currentStep,
                    totalSteps: 6,
                  ),
                  SizedBox(height: 12.h),
                  CoachStepIndicators(
                    currentStep: cubit.currentStep,
                    totalSteps: 6,
                    onStepTapped: cubit.goToStep,
                  ),
                  SizedBox(height: 16.h),
                  Expanded(child: _buildStepContent(cubit)),
                  CoachActionButtons(
                    currentStep: cubit.currentStep,
                    totalSteps: 6,
                    isLoading: isLoading,
                    onNext: cubit.nextStep,
                    onBack: cubit.previousStep,
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

  Widget _buildStepContent(CoachSetupCubit cubit) {
    switch (cubit.currentStep) {
      case 0:
        return StepPersonalInfoWidget(cubit: cubit);
      case 1:
        return StepProfessionalInfoWidget(cubit: cubit);
      case 2:
        return StepPricingWidget(cubit: cubit);
      case 3:
        return StepAvailabilityWidget(cubit: cubit);
      case 4:
        return StepVerificationDocsWidget(cubit: cubit);
      case 5:
        return StepReviewSubmitWidget(cubit: cubit);
      default:
        return StepPersonalInfoWidget(cubit: cubit);
    }
  }
}
