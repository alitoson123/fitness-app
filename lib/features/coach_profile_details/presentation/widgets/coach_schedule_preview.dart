import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/core/widgets/availability_selector/availability_helper.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoachSchedulePreview extends StatelessWidget {
  final CoachProfileModel coach;

  const CoachSchedulePreview({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 18.r, color: primary),
              SizedBox(width: 8.w),
              Text(
                S.of(context).weeklyAvailabilityTitle,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (coach.weeklyAvailability.isNotEmpty)
            _buildScheduleList(context, isDark, primary, textSecondary)
          else if (coach.availabilitySummary.isNotEmpty)
            _buildSummaryCard(context, isDark, primary, textSecondary)
          else
            _buildEmptyState(context, textSecondary),
        ],
      ),
    );
  }

  Widget _buildScheduleList(
    BuildContext context,
    bool isDark,
    Color primary,
    Color textSecondary,
  ) {
    return Column(
      children: coach.weeklyAvailability.map((item) {
        final dayName = AvailabilityHelper.getDayFullName(context, item.day);
        final isAvail = item.isAvailable;
        final timeRange = isAvail
            ? '${AvailabilityHelper.formatTime(context, item.fromTime)} - ${AvailabilityHelper.formatTime(context, item.toTime)}'
            : S.of(context).dayUnavailable;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAvail ? AppColors.success : AppColors.neutral400,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isAvail ? FontWeight.w600 : FontWeight.w400,
                      color: isAvail ? null : textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                timeRange,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isAvail ? FontWeight.w600 : FontWeight.w400,
                  color: isAvail ? primary : textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    bool isDark,
    Color primary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Icon(Icons.access_time_rounded, size: 16.r, color: primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            coach.availabilitySummary,
            style: TextStyle(fontSize: 13.sp, color: textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, Color textSecondary) {
    return Text(
      S.of(context).noAvailabilityListed,
      style: TextStyle(fontSize: 13.sp, color: textSecondary),
    );
  }
}
