import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class IllustrationStatsCard extends StatelessWidget {
  const IllustrationStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Streak Banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.flameGradient),
              borderRadius: AppRadius.fullAll,
              boxShadow: [
                BoxShadow(
                  color: AppColors.flameRed.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 20),
                SizedBox(width: 6.w),
                Text(
                  '5-Day Workout Streak!',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          // Metric Cards Row
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.whatshot_rounded,
                  label: 'Calories',
                  value: '680 kcal',
                  color: AppColors.flameRed,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.timer_outlined,
                  label: 'Duration',
                  value: '45 mins',
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.emoji_events_rounded,
                  label: 'Goal',
                  value: '100%',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22.r, color: color),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
