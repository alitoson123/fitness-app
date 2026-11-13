import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_cubit.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_state.dart';
import '../view_model/training_insights_cubit/training_insights_cubit.dart';
import '../widgets/trainee_account_settings_section.dart';
import '../widgets/trainee_profile_fitness_card_widget.dart';
import '../widgets/trainee_profile_header_widget.dart';
import '../widgets/trainee_profile_training_insights_card.dart';

class TraineeProfilePage extends StatelessWidget {
  const TraineeProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TraineeProfileCubit>()..loadProfile(),
        ),
        BlocProvider(
          create: (_) => getIt<TrainingInsightsCubit>()..loadInsights(),
        ),
      ],
      child: const _TraineeProfileContent(),
    );
  }
}

class _TraineeProfileContent extends StatelessWidget {
  const _TraineeProfileContent();

  void _handleStateMessages(BuildContext context, TraineeProfileState state) {
    final s = S.of(context);
    final cubit = context.read<TraineeProfileCubit>();
    if (state.successMessage == 'profile_updated') {
      Message.showSuccess(context, s.profileUpdatedSuccess);
      cubit.clearMessages();
    } else if (state.successMessage == 'avatar_updated') {
      Message.showSuccess(context, s.avatarUpdatedSuccess);
      cubit.clearMessages();
    } else if (state.errorMessage != null) {
      Message.showError(context, state.errorMessage!);
      cubit.clearMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).traineeProfileTitle),
        centerTitle: true,
      ),
      body: BlocConsumer<TraineeProfileCubit, TraineeProfileState>(
        listener: _handleStateMessages,
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.profile == null) {
            return _buildError(context);
          }
          final profile = state.profile;
          if (profile == null) return const SizedBox.shrink();

          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                context.read<TraineeProfileCubit>().loadProfile(),
                context
                    .read<TrainingInsightsCubit>()
                    .loadInsights(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  TraineeProfileHeaderWidget(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  TraineeProfileFitnessCardWidget(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  const TraineeProfileTrainingInsightsCard(),
                  SizedBox(height: AppSpacing.s4),
                  const TraineeAccountSettingsSection(),
                  SizedBox(height: AppSpacing.s5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.r,
            color: AppColors.error,
          ),
          SizedBox(height: 12.h),
          Text(s.loadProfileError),
          SizedBox(height: 16.h),
          AppButton(
            label: s.tryAgain,
            size: AppButtonSize.sm,
            onPressed: () =>
                context.read<TraineeProfileCubit>().loadProfile(),
          ),
        ],
      ),
    );
  }
}
