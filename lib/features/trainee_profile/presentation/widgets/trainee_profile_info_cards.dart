import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';

class TraineeProfileInfoCards extends StatelessWidget {
  final TraineeProfileModel profile;

  const TraineeProfileInfoCards({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final ageValue = profile.age > 0 ? '${profile.age}' : '-';
    final genderValue =
        profile.gender.isNotEmpty ? profile.gender : s.notSpecified;

    return Row(
      children: [
        Expanded(
          child: _InfoStatCard(
            icon: Icons.cake_outlined,
            title: s.reviewAge,
            value: ageValue,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _InfoStatCard(
            icon: Icons.person_outline_rounded,
            title: s.reviewGender,
            value: genderValue,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _InfoStatCard(
            icon: Icons.fitness_center_rounded,
            title: s.role,
            value: s.trainee,
          ),
        ),
      ],
    );
  }
}

class _InfoStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoStatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final iconColor = isDark ? AppColors.flameRed : AppColors.primary;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20.r, color: iconColor),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
