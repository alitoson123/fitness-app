import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class IllustrationCoachCard extends StatelessWidget {
  const IllustrationCoachCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Central Avatar with Verified Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.flameGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.flameRed.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.sports_martial_arts_rounded,
                  size: 48.r,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 14.r, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Rating and session count
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: AppRadius.fullAll,
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 18, color: AppColors.warning),
                SizedBox(width: 4.w),
                Text(
                  '4.9',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '• 150+ Sessions',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Specialty chips row
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            alignment: WrapAlignment.center,
            children: [
              _buildSpecialtyChip('Gym', AppColors.flameRed),
              _buildSpecialtyChip('Boxing', AppColors.secondary),
              _buildSpecialtyChip('Swimming', AppColors.primary400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.fullAll,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
