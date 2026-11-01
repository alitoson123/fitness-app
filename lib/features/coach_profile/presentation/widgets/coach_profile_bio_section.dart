import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

class CoachProfileBioSection extends StatelessWidget {
  final CoachProfileModel profile;

  const CoachProfileBioSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

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
            children: [
              Icon(Icons.person_pin_rounded,
                  size: 18.r, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                s.aboutCoach,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              if (profile.yearsOfExperience > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: AppRadius.smAll,
                  ),
                  child: Text(
                    s.yearsExperienceFormat(profile.yearsOfExperience),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.s3),
          Text(
            profile.bio.isNotEmpty ? profile.bio : s.noBioProvided,
            style: TextStyle(
              fontSize: 13.sp,
              color: textSecondary,
              height: 1.4,
            ),
          ),
          if (profile.languages.isNotEmpty) ...[
            SizedBox(height: AppSpacing.s3),
            Text(
              s.spokenLanguages,
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
              children: profile.languages.map((lang) {
                return _buildChip(context, label: lang);
              }).toList(),
            ),
          ],
          if (profile.specialties.isNotEmpty) ...[
            SizedBox(height: AppSpacing.s3),
            Text(
              s.specialtiesLabel,
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
              children: profile.specialties.map((spec) {
                return _buildChip(context, label: spec);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, {required String label}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.surfaceVariant;
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11.sp, color: textColor),
      ),
    );
  }
}
