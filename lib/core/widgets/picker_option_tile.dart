import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class PickerOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const PickerOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      leading: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: AppRadius.mdAll,
        ),
        child: Icon(icon, color: color, size: 20.r),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
