import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';

class TraineeProfileFitnessSection extends StatelessWidget {
  final TraineeProfileModel profile;

  const TraineeProfileFitnessSection({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final goalText =
        profile.goal.isNotEmpty ? profile.goal : s.notSpecified;
    final levelText =
        profile.level.isNotEmpty ? profile.level : s.notSpecified;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.fitnessProfile,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.s3),
          _FitnessRowItem(
            icon: Icons.flag_rounded,
            title: s.fitnessGoal,
            value: goalText,
          ),
          Divider(height: 20.h, color: borderColor),
          _FitnessRowItem(
            icon: Icons.trending_up_rounded,
            title: s.fitnessLevel,
            value: levelText,
          ),
          Divider(height: 20.h, color: borderColor),
          Text(
            s.favoriteSports,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          if (profile.sports.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: profile.sports.map((sport) {
                return _SportTag(name: sport);
              }).toList(),
            )
          else
            Text(
              s.noSportsSelected,
              style: TextStyle(
                fontSize: 13.sp,
                color: textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}

class _FitnessRowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _FitnessRowItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final iconColor = isDark ? AppColors.flameRed : AppColors.primary;

    return Row(
      children: [
        Icon(icon, size: 18.r, color: iconColor),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SportTag extends StatelessWidget {
  final String name;

  const _SportTag({required this.name});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.flameRed : AppColors.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.12),
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    );
  }
}
