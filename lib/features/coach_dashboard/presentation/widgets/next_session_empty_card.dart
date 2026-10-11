import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class NextSessionEmptyCard extends StatelessWidget {
  final VoidCallback onSetAvailability;

  const NextSessionEmptyCard({super.key, required this.onSetAvailability});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = S.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.flameRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  size: 20.r,
                  color: AppColors.flameRed,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.noUpcomingSessionsTitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      s.noUpcomingSessionsDesc,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSetAvailability,
              icon: Icon(Icons.schedule_rounded, size: 16.r),
              label: Text(
                s.setAvailabilityButton,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.flameRed,
                side: const BorderSide(color: AppColors.flameRed, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
