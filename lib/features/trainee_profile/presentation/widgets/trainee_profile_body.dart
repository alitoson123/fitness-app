import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_cubit.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_states.dart';
import 'trainee_profile_actions.dart';
import 'trainee_profile_fitness_section.dart';
import 'trainee_profile_header.dart';
import 'trainee_profile_info_cards.dart';

class TraineeProfileBody extends StatelessWidget {
  const TraineeProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraineeProfileCubit, TraineeProfileState>(
      builder: (context, state) {
        if (state is TraineeProfileLoadingState ||
            state is TraineeProfileInitialState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TraineeProfileErrorState) {
          return _buildErrorState(context, state.errorMessage);
        }

        if (state is TraineeProfileSuccessState) {
          final profile = state.profile;

          return RefreshIndicator(
            onRefresh: () => context
                .read<TraineeProfileCubit>()
                .loadProfile(forceRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  TraineeProfileHeader(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  TraineeProfileInfoCards(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  TraineeProfileFitnessSection(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  const TraineeProfileActions(),
                  SizedBox(height: AppSpacing.s4),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.r, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              s.loadProfileError,
              style: TextStyle(fontSize: 14.sp, color: textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            AppButton(
              label: s.tryAgain,
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.sm,
              onPressed: () => context
                  .read<TraineeProfileCubit>()
                  .loadProfile(forceRefresh: true),
            ),
          ],
        ),
      ),
    );
  }
}
