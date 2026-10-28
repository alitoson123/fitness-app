import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import 'quick_action_tile.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback onManageAvailability;
  final VoidCallback onViewBookings;
  final double monthlyEarnings;
  final String currency;

  const QuickActionsSection({
    super.key,
    required this.onManageAvailability,
    required this.onViewBookings,
    this.monthlyEarnings = 0.0,
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.quickActions,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        QuickActionTile(
          icon: Icons.schedule_rounded,
          title: s.quickActionAvailability,
          subtitle: s.quickActionAvailabilityDesc,
          onTap: onManageAvailability,
        ),
        SizedBox(height: 10.h),
        QuickActionTile(
          icon: Icons.calendar_month_rounded,
          title: s.quickActionBookings,
          subtitle: s.quickActionBookingsDesc,
          onTap: onViewBookings,
        ),
        if (monthlyEarnings > 0) ...[
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.flameRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 20.r,
                    color: AppColors.flameRed,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    s.thisMonthEarnings,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${monthlyEarnings.toInt()} $currency',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.flameRed,
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
