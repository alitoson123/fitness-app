import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class BookingCardInfo extends StatelessWidget {
  final String dateFormatted;
  final String startTime;
  final String endTime;
  final bool isDark;
  final bool isMonthly;

  const BookingCardInfo({
    super.key,
    required this.dateFormatted,
    required this.startTime,
    required this.endTime,
    required this.isDark,
    this.isMonthly = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final textStyle = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            isMonthly
                ? Icons.calendar_month_rounded
                : Icons.calendar_today_rounded,
            size: 12.sp,
            color: AppColors.darkTextSecondary,
          ),
          SizedBox(width: 5.w),
          Text(dateFormatted, style: textStyle),
          const Spacer(),
          Icon(
            isMonthly ? Icons.repeat_rounded : Icons.access_time_rounded,
            size: 12.sp,
            color: AppColors.darkTextSecondary,
          ),
          SizedBox(width: 5.w),
          Text(
            isMonthly ? s.monthlyPackageType : '$startTime - $endTime',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
