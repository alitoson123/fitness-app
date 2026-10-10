import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoachBioSection extends StatelessWidget {
  final CoachProfileModel coach;

  const CoachBioSection({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final bioText =
        coach.bio.trim().isNotEmpty ? coach.bio : S.of(context).defaultCoachBio;

    return Container(
      width: double.infinity,
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
            children: [
              Icon(Icons.person_outline_rounded, size: 18.r, color: primary),
              SizedBox(width: 8.w),
              Text(
                S.of(context).aboutCoach,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            bioText,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: textSecondary,
            ),
          ),
          if (coach.specialties.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildSpecialties(isDark, textPrimary, textSecondary),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecialties(
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).specialties,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: coach.specialties.map((spec) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04),
                    borderRadius: AppRadius.smAll,
                  ),
                  child: Text(
                    spec,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
