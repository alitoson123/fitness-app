import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class PricingTipCard extends StatelessWidget {
  const PricingTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              size: 16.r,
              color: primary,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              S.of(context).pricingTipText,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
