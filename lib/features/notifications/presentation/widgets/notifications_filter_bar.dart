import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/notifications_cubit/notifications_state.dart';

class NotificationsFilterBar extends StatelessWidget {
  final NotificationFilter activeFilter;
  final int allCount;
  final int bookingsCount;
  final int adminCount;
  final ValueChanged<NotificationFilter> onFilterChanged;

  const NotificationsFilterBar({
    super.key,
    required this.activeFilter,
    required this.allCount,
    required this.bookingsCount,
    required this.adminCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _buildFilterChip(
            context,
            filter: NotificationFilter.all,
            label: s.filterAll,
            count: allCount,
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            context,
            filter: NotificationFilter.bookings,
            label: s.filterBookings,
            count: bookingsCount,
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            context,
            filter: NotificationFilter.admin,
            label: s.filterAdmin,
            count: adminCount,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required NotificationFilter filter,
    required String label,
    required int count,
  }) {
    final isSelected = activeFilter == filter;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkSurfaceVariant : AppColors.neutral100);

    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkTextSecondary : AppColors.neutral500);

    return InkWell(
      onTap: () => onFilterChanged(filter),
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.neutral200),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : (isDark ? AppColors.darkBorder : AppColors.neutral200),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
