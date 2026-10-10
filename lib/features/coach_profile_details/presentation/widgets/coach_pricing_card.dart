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
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: primary.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                S.of(context).sessionPricing,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${coach.sessionPrice.toStringAsFixed(0)} ${coach.currency}',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    S.of(context).perSessionUnit,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 20.h, color: primary.withValues(alpha: 0.15)),
          Text(
            S.of(context).whatsIncluded,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          _buildCheckItem(S.of(context).oneOnOneTraining, primary, textSecondary),
          SizedBox(height: 6.h),
          _buildCheckItem(S.of(context).customWorkoutPlan, primary, textSecondary),
          SizedBox(height: 6.h),
          _buildCheckItem(S.of(context).directSupport, primary, textSecondary),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, Color primary, Color textSecondary) {
    return Row(
      children: [
        Icon(Icons.check_circle_rounded, size: 16.r, color: primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: textSecondary),
          ),
        ),
      ],
    );
  }
}
