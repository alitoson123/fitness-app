import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class CoachDashboardSkeleton extends StatelessWidget {
  const CoachDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.backgroundSecondary;

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.s2),
          _buildBox(height: 76.h, color: placeholderColor, radius: AppRadius.lgAll),
          SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(child: _buildBox(height: 64.h, color: placeholderColor)),
              SizedBox(width: 8.w),
              Expanded(child: _buildBox(height: 64.h, color: placeholderColor)),
              SizedBox(width: 8.w),
              Expanded(child: _buildBox(height: 64.h, color: placeholderColor)),
            ],
          ),
          SizedBox(height: AppSpacing.s3),
          _buildBox(height: 120.h, color: placeholderColor, radius: AppRadius.lgAll),
          SizedBox(height: AppSpacing.s3),
          _buildBox(height: 70.h, color: placeholderColor, radius: AppRadius.mdAll),
          SizedBox(height: AppSpacing.s3),
          _buildBox(height: 100.h, color: placeholderColor, radius: AppRadius.mdAll),
        ],
      ),
    );
  }

  Widget _buildBox({
    required double height,
    required Color color,
    BorderRadius? radius,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius ?? AppRadius.mdAll,
      ),
    );
  }
}
