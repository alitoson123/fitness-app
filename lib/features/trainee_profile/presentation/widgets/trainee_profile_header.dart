import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';

class TraineeProfileHeader extends StatelessWidget {
  final TraineeProfileModel profile;

  const TraineeProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final hasLocation =
        profile.city.isNotEmpty || profile.country.isNotEmpty;
    final locationText = [
      if (profile.city.isNotEmpty) profile.city,
      if (profile.country.isNotEmpty) profile.country,
    ].join(', ');

    return Column(
      children: [
        CircleAvatar(
          radius: 44.r,
          backgroundColor:
              isDark ? AppColors.darkBorder : AppColors.primary100,
          backgroundImage: profile.photoUrl != null &&
                  profile.photoUrl!.isNotEmpty
              ? NetworkImage(profile.photoUrl!)
              : null,
          child: profile.photoUrl == null || profile.photoUrl!.isEmpty
              ? Icon(
                  Icons.person_rounded,
                  size: 48.r,
                  color: isDark ? AppColors.flameRed : AppColors.primary,
                )
              : null,
        ),
        SizedBox(height: AppSpacing.s3),
        Text(
          profile.name.isNotEmpty ? profile.name : 'Trainee',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        if (profile.email.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            profile.email,
            style: TextStyle(
              fontSize: 13.sp,
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (hasLocation) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : AppColors.neutral100,
              borderRadius: AppRadius.fullAll,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 14.r,
                  color: isDark ? AppColors.flameRed : AppColors.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  locationText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
