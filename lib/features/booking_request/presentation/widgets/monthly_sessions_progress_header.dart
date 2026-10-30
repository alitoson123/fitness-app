import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class MonthlySessionsProgressHeader extends StatelessWidget {
  final int currentCount;
  final int totalRequired;
  final VoidCallback onClearAll;

  const MonthlySessionsProgressHeader({
    super.key,
    required this.currentCount,
    required this.totalRequired,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final progress = (currentCount / totalRequired).clamp(0.0, 1.0);
    final isComplete = currentCount >= totalRequired;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.mdAll,
        border: Border.all(
          color: isComplete ? Colors.green.withValues(alpha: 0.6) : border,
          width: isComplete ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isComplete
                    ? Icons.check_circle_rounded
                    : Icons.calendar_month_rounded,
                size: 20.r,
                color: isComplete ? Colors.green : primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  s.monthlySessionsProgress(currentCount, totalRequired),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: isComplete ? Colors.green : textPrimary,
                  ),
                ),
              ),
              if (currentCount > 0)
                GestureDetector(
                  onTap: onClearAll,
                  child: Text(
                    s.clearAllSessions,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: isDark
                  ? AppColors.darkBackground
                  : AppColors.backgroundSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? Colors.green : primary,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            s.selectRequiredSessionsPrompt(totalRequired),
            style: TextStyle(fontSize: 11.sp, color: textSecondary),
          ),
        ],
      ),
    );
  }
}
