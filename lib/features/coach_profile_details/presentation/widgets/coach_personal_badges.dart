import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoachPersonalBadges extends StatelessWidget {
  final CoachProfileModel coach;

  const CoachPersonalBadges({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final genderKey = coach.gender.trim().toLowerCase();
    final hasGender = genderKey.isNotEmpty && genderKey != 'all';
    final hasAge = coach.age > 0;

    if (!hasGender && !hasAge) {
      return const SizedBox.shrink();
    }

    final isFemale = genderKey == 'female';
    final isMale = genderKey == 'male';

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.w,
      runSpacing: 6.h,
      children: [
        if (hasGender)
          _buildBadge(
            context: context,
            icon: isFemale
                ? Icons.female_rounded
                : (isMale ? Icons.male_rounded : Icons.person_outline_rounded),
            iconColor: isFemale
                ? (isDark ? const Color(0xFFF48FB1) : const Color(0xFFD81B60))
                : (isMale
                    ? (isDark
                        ? const Color(0xFF90CAF9)
                        : const Color(0xFF1976D2))
                    : textSecondary),
            label: isFemale
                ? s.female
                : (isMale ? s.male : s.preferNotToSay),
            isDark: isDark,
            textSecondary: textSecondary,
          ),
        if (hasAge)
          _buildBadge(
            context: context,
            icon: Icons.cake_outlined,
            iconColor: isDark
                ? const Color(0xFFFFB74D)
                : const Color(0xFFF57C00),
            label: s.coachAgeYears(coach.age),
            isDark: isDark,
            textSecondary: textSecondary,
          ),
      ],
    );
  }

  Widget _buildBadge({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool isDark,
    required Color textSecondary,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: AppRadius.fullAll,
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.6)
              : AppColors.border.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: iconColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
