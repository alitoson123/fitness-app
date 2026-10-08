import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_status_cubit/coach_status_cubit.dart';
import '../view_model/coach_status_cubit/coach_status_states.dart';
import '../widgets/pending_status_card.dart';
import '../widgets/rejection_feedback_card.dart';

class CoachVerificationPendingView extends StatelessWidget {
  const CoachVerificationPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoachStatusCubit>()..checkStatus(),
      child: const _CoachVerificationPendingBody(),
    );
  }
}

class _CoachVerificationPendingBody extends StatelessWidget {
  const _CoachVerificationPendingBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).verificationPendingTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 22.r),
            onPressed: () => context.read<CoachStatusCubit>().checkStatus(),
          ),
        ],
      ),
      body: BlocConsumer<CoachStatusCubit, CoachStatusState>(
        listener: (context, state) {
          if (state is CoachStatusApprovedState) {
            Message.showSuccess(
              context,
              S.of(context).applicationApprovedWelcome,
            );
            context.go(AppRoutes.coachDashboard);
          } else if (state is CoachStatusSignedOutState) {
            context.go(AppRoutes.signIn);
          } else if (state is CoachStatusErrorState) {
            Message.showError(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is CoachStatusLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  SizedBox(height: AppSpacing.s4),
                  if (state is CoachStatusRejectedState)
                    RejectionFeedbackCard(
                      application: state.application,
                      rejectionReason: state.rejectionReason,
                      onEditAndResubmit: () {
                        context.go(
                          AppRoutes.coachRegistration,
                          extra: (state.profile, state.application),
                        );
                      },
                    )
                  else if (state is CoachStatusPendingState)
                    PendingStatusCard(application: state.application)
                  else
                    _buildFallbackError(context),
                  SizedBox(height: AppSpacing.s6),
                  AppButton(
                    label: S.of(context).checkStatusAgain,
                    variant: AppButtonVariant.secondary,
                    fullWidth: true,
                    icon: Icon(Icons.refresh_rounded, size: 18.r),
                    onPressed: () =>
                        context.read<CoachStatusCubit>().checkStatus(),
                  ),
                  SizedBox(height: AppSpacing.s3),
                  AppButton(
                    label: S.of(context).signOut,
                    variant: AppButtonVariant.outlined,
                    fullWidth: true,
                    icon: Icon(Icons.logout_rounded, size: 18.r),
                    onPressed: () =>
                        context.read<CoachStatusCubit>().signOut(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallbackError(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          S.of(context).applicationNotFound,
          style: TextStyle(
            fontSize: 14.sp,
            color: textSecondary,
          ),
        ),
      ),
    );
  }
}
