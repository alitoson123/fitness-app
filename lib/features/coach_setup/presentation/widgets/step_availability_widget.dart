import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/availability_selector/availability_helper.dart';
import '../../../../core/widgets/availability_selector/availability_selector.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';

class StepAvailabilityWidget extends StatelessWidget {
  final CoachSetupCubit cubit;

  const StepAvailabilityWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).stepAvailability,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).availabilityStepSubtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          AvailabilitySelector(
            schedule: cubit.weeklyAvailability,
            onScheduleChanged: (schedule) {
              final summary = AvailabilityHelper.formatSummary(
                context,
                schedule,
              );
              cubit.setWeeklyAvailability(schedule, summary);
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
