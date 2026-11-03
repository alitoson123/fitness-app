import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../view_model/training_insights_cubit/training_insights_cubit.dart';
import '../view_model/training_insights_cubit/training_insights_state.dart';
import 'training_insights_period_header.dart';
import 'training_insights_period_selector.dart';
import 'training_insights_stat_content.dart';

class TraineeProfileTrainingInsightsCard extends StatelessWidget {
  const TraineeProfileTrainingInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: BlocBuilder<TrainingInsightsCubit, TrainingInsightsState>(
        builder: (context, state) {
          final cubit = context.read<TrainingInsightsCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insights_rounded,
                    size: 18.r,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    s.trainingInsightsTitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s3),
              TrainingInsightsPeriodSelector(
                selectedPeriod: state.selectedPeriod,
                onPeriodSelected: cubit.selectPeriod,
              ),
              SizedBox(height: AppSpacing.s3),
              TrainingInsightsPeriodHeader(
                period: state.selectedPeriod,
                date: state.selectedDate,
                canGoForward: state.canGoForward,
                onPrevious: cubit.previousPeriod,
                onNext: cubit.nextPeriod,
              ),
              SizedBox(height: AppSpacing.s2),
              if (state.isLoading && state.bookings.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else
                TrainingInsightsStatContent(
                  uniqueDays: state.currentPeriodUniqueDays,
                  period: state.selectedPeriod,
                ),
            ],
          );
        },
      ),
    );
  }
}

