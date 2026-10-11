import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_states.dart';

class BookingsTabBar extends StatelessWidget {
  final CoachBookingTab selectedTab;
  final int pendingCount;
  final int confirmedCount;
  final ValueChanged<CoachBookingTab> onTabChanged;

  const BookingsTabBar({
    super.key,
    required this.selectedTab,
    required this.pendingCount,
    required this.confirmedCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12.r),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Row(
        children: [
          _buildTab(
            label: s.incomingRequestsTab,
            count: pendingCount,
            isSelected: selectedTab == CoachBookingTab.pending,
            onTap: () => onTabChanged(CoachBookingTab.pending),
            badgeColor: AppColors.flameRed,
            isDark: isDark,
          ),
          _buildTab(
            label: s.confirmedSessionsTab,
            count: confirmedCount,
            isSelected: selectedTab == CoachBookingTab.confirmed,
            onTap: () => onTabChanged(CoachBookingTab.confirmed),
            badgeColor: AppColors.success,
            isDark: isDark,
          ),
          _buildTab(
            label: s.pastSessionsTab,
            isSelected: selectedTab == CoachBookingTab.past,
            onTap: () => onTabChanged(CoachBookingTab.past),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    int? count,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    Color? badgeColor,
  }) {
    final selectedBg = isDark
        ? AppColors.flameRed.withValues(alpha: 0.15)
        : Colors.white;
    final selectedBorder = isDark ? AppColors.flameRed : Colors.transparent;
    final selectedTextColor = isDark ? AppColors.flameRed : AppColors.primary;
    final unselectedTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? selectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(9.r),
              border: Border.all(
                color: isSelected ? selectedBorder : Colors.transparent,
                width: 1.2,
              ),
              boxShadow: (!isDark && isSelected)
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? selectedTextColor : unselectedTextColor,
                  ),
                ),
                if (count != null && count > 0) ...[
                  SizedBox(width: 5.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor ?? AppColors.flameRed,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
