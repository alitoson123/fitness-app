import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class RescheduleSheetHeader extends StatelessWidget {
  final BookingModel? booking;

  const RescheduleSheetHeader({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              borderRadius: AppRadius.fullAll,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          s.rescheduleSession,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        if (booking != null) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.fitness_center_rounded, size: 12.r, color: AppColors.flameRed),
              SizedBox(width: 4.w),
              Text(
                booking!.sport,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.flameRed),
              ),
              if (booking!.isOnline || booking!.trainingLocation.isNotEmpty) ...[
                Text(' • ', style: TextStyle(fontSize: 12.sp, color: textSecondary)),
                Icon(
                  booking!.isOnline ? Icons.laptop_chromebook_rounded : Icons.location_on_rounded,
                  size: 12.r,
                  color: textSecondary,
                ),
                SizedBox(width: 3.w),
                Text(
                  booking!.isOnline ? s.onlineTrainingOption : booking!.trainingLocation,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textSecondary),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
