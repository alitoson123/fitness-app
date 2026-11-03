import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../helpers/training_insights_calculator.dart';

class TrainingInsightsPeriodHeader extends StatelessWidget {
  final TrainingPeriod period;
  final DateTime date;
  final bool canGoForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const TrainingInsightsPeriodHeader({
    super.key,
    required this.period,
    required this.date,
    required this.canGoForward,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = TrainingInsightsCalculator.formatPeriodTitle(
      context,
      period,
      date,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavArrow(
          icon: Icons.chevron_left_rounded,
          onTap: onPrevious,
          isEnabled: true,
          isDark: isDark,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13.r,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        _NavArrow(
          icon: Icons.chevron_right_rounded,
          onTap: onNext,
          isEnabled: canGoForward,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isDark;

  const _NavArrow({
    required this.icon,
    required this.onTap,
    required this.isEnabled,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final disabledColor =
        isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: Icon(
          icon,
          size: 20.r,
          color: isEnabled ? activeColor : disabledColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

