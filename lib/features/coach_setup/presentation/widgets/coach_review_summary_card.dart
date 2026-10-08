import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class CoachReviewSummaryCard extends StatelessWidget {
  final String title;
  final int stepIndex;
  final List<(String, String)> items;
  final ValueChanged<int> onEditTapped;

  const CoachReviewSummaryCard({
    super.key,
    required this.title,
    required this.stepIndex,
    required this.items,
    required this.onEditTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6.r),
                onTap: () => onEditTapped(stepIndex),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Text(
                    S.of(context).edit,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 16.h,
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          ...items.map((item) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Text(
                      item.$1,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
