import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_status_cubit/coach_status_cubit.dart';
import '../view_model/coach_status_cubit/coach_status_states.dart';
import '../widgets/coach_status_action_buttons.dart';
import '../widgets/contact_support_dialog.dart';
import '../widgets/pending_status_card.dart';
import '../widgets/rejection_feedback_card.dart';

class CoachVerificationPendingView extends StatelessWidget {
  const CoachVerificationPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CoachVerificationStatusCubit>()..listenToVerificationStatus(),
      child: const _CoachVerificationPendingBody(),
    );
  }
}

class _CoachVerificationPendingBody extends StatelessWidget {
  const _CoachVerificationPendingBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoachVerificationStatusCubit,
        CoachVerificationStatusState>(
      listener: (context, state) {
        if (state is CoachVerificationStatusApprovedState) {
          Message.showSuccess(context, S.of(context).applicationApprovedWelcome);
          context.go(AppRoutes.coachDashboard);
        } else if (state is CoachVerificationStatusSignedOutState) {
          context.go(AppRoutes.signIn);
        } else if (state is CoachVerificationStatusErrorState) {
          Message.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        final s = S.of(context);
        final title = state is CoachVerificationStatusRejectedState
            ? s.applicationNeedsAttention
            : s.verificationPendingTitle;

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh_rounded, size: 22.r),
                onPressed: () =>
                    context.read<CoachVerificationStatusCubit>().checkStatus(),
              ),
            ],
          ),
          body: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(
      BuildContext context, CoachVerificationStatusState state) {
    if (state is CoachVerificationStatusLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    final cubit = context.read<CoachVerificationStatusCubit>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            SizedBox(height: AppSpacing.s4),
            if (state is CoachVerificationStatusRejectedState) ...[
              RejectionFeedbackCard(
                application: state.application,
                rejectionReason: state.rejectionReason,
                onEditAndResubmit: () => context.go(
                  AppRoutes.coachRegistration,
                  extra: (state.profile, state.application),
                ),
              ),
              SizedBox(height: AppSpacing.s4),
              CoachStatusActionButtons(
                onRefresh: () => cubit.checkStatus(),
                onSignOut: () => cubit.signOut(),
              ),
            ] else if (state is CoachVerificationStatusPendingState) ...[
              PendingStatusCard(
                application: state.application,
                onContactSupport: () => ContactSupportDialog.show(context),
              ),
              SizedBox(height: AppSpacing.s4),
              CoachStatusActionButtons(
                onRefresh: () => cubit.checkStatus(),
                onSignOut: () => cubit.signOut(),
              ),
            ] else
              _buildFallbackError(context, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackError(
      BuildContext context, CoachVerificationStatusCubit cubit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Text(
              S.of(context).applicationNotFound,
              style: TextStyle(fontSize: 14.sp, color: textSecondary),
            ),
            SizedBox(height: AppSpacing.s4),
            CoachStatusActionButtons(
              onRefresh: () => cubit.checkStatus(),
              onSignOut: () => cubit.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
