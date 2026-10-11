import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class BookingsGroupHeader extends StatelessWidget {
  final String title;
  final int count;

  const BookingsGroupHeader({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: AppColors.flameRed,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
