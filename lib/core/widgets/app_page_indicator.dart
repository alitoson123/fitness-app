import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class AppPageIndicator extends StatelessWidget {
  final int total;
  final int current;

  const AppPageIndicator({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 24.w : 8.w,
          height: 8.h,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: AppRadius.fullAll,
          ),
        );
      }),
    );
  }
}
