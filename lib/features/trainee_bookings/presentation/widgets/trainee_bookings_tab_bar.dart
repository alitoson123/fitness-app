import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../view_model/trainee_bookings_cubit/trainee_bookings_states.dart';

class TraineeBookingsTabBar extends StatelessWidget {
  final TraineeBookingTab selectedTab;
  final int activeCount;
  final int historyCount;
  final ValueChanged<TraineeBookingTab> onTabChanged;

  const TraineeBookingsTabBar({
    super.key,
    required this.selectedTab,
    required this.activeCount,
    required this.historyCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'Active ($activeCount)',
              isSelected: selectedTab == TraineeBookingTab.active,
              onTap: () => onTabChanged(TraineeBookingTab.active),
              isDark: isDark,
            ),
          ),
          Expanded(
            child: _TabButton(
              title: 'History ($historyCount)',
              isSelected: selectedTab == TraineeBookingTab.history,
              onTap: () => onTabChanged(TraineeBookingTab.history),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.smAll,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkSurface : Colors.white)
              : Colors.transparent,
          borderRadius: AppRadius.smAll,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.primary
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
