import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class SportDeliveryBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final bool isPrimaryStyle;

  const SportDeliveryBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    this.isPrimaryStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPrimaryStyle
        ? color.withValues(alpha: isDark ? 0.16 : 0.10)
        : (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant);
    final border = isPrimaryStyle
        ? color.withValues(alpha: 0.35)
        : (isDark ? AppColors.darkBorder : AppColors.border);
    final textColor = isPrimaryStyle
        ? color
        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);
    final iconColor = isPrimaryStyle ? color : color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.smAll,
        border: Border.all(color: border, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: iconColor),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isPrimaryStyle ? FontWeight.w700 : FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

