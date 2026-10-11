import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoachPricingCard extends StatelessWidget {
  final CoachProfileModel coach;

  const CoachPricingCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark
        ? AppColors.darkSurface
        : const Color(0xFFF0F5FF);
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: primary.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).pricePerSession,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          Text(
            '${coach.currency} ${coach.sessionPrice.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}
