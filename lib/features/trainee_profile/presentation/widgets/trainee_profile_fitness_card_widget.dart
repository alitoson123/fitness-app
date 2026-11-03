import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';
import 'edit_trainee_profile_sheet.dart';
import 'trainee_profile_formatters.dart';
import 'trainee_profile_stat_tile.dart';

class TraineeProfileFitnessCardWidget extends StatelessWidget {
  final TraineeProfileModel profile;

  const TraineeProfileFitnessCardWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    final ageVal = profile.age > 0 ? '${profile.age}' : '-';
    final ageSub = profile.age > 0 ? s.yearsUnit : '';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.fitnessOverviewTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => EditTraineeProfileSheet.show(context, profile),
                borderRadius: AppRadius.smAll,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        s.editFitnessAction,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: TraineeProfileStatTile(
                  title: s.reviewAge,
                  value: ageVal,
                  subtitle: ageSub,
                  icon: Icons.cake_outlined,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TraineeProfileStatTile(
                  title: s.reviewGender,
                  value: TraineeProfileFormatters.formatGender(
                    context,
                    profile.gender,
                  ),
                  subtitle: '',
                  icon: Icons.person_outline_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: TraineeProfileStatTile(
                  title: s.fitnessLevel,
                  value: TraineeProfileFormatters.formatLevel(
                    context,
                    profile.level,
                  ),
                  subtitle: '',
                  icon: Icons.trending_up_rounded,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TraineeProfileStatTile(
                  title: s.fitnessGoal,
                  value: TraineeProfileFormatters.formatGoal(
                    context,
                    profile.goal,
                  ),
                  subtitle: '',
                  icon: Icons.flag_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
