import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_radius.dart';

class CoachInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  const CoachInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: textSecondary),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
