import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class BookingsSkeleton extends StatelessWidget {
  const BookingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.backgroundSecondary;

    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.r),
          height: 120.h,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 12.h, width: 100.w, color: color),
                        SizedBox(height: 4.h),
                        Container(height: 10.h, width: 60.w, color: color),
                      ],
                    ),
                  ),
                  Container(height: 14.h, width: 50.w, color: color),
                ],
              ),
              const Spacer(),
              Container(
                height: 28.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
