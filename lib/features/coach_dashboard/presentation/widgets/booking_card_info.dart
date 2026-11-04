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
  final int sessionsCount;
  final String? location;
  final bool isOnline;

  const BookingCardInfo({
    super.key,
    required this.dateFormatted,
    required this.startTime,
    required this.endTime,
    required this.isDark,
    this.isMonthly = false,
    this.sessionsCount = 0,
    this.location,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final textStyle = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
    );

    final monthlyLabel = sessionsCount > 1
        ? '${s.monthlyPackageType} ($sessionsCount)'
        : s.monthlyPackageType;

    final hasLocation = isOnline || (location != null && location!.isNotEmpty);
    final locationLabel = isOnline
        ? s.onlineTrainingOption
        : (location ?? '');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
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
                isMonthly ? monthlyLabel : '$startTime - $endTime',
                style: textStyle,
              ),
            ],
          ),
          if (hasLocation) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  isOnline
                      ? Icons.laptop_chromebook_rounded
                      : Icons.location_on_rounded,
                  size: 12.sp,
                  color: isDark ? AppColors.flameRed : AppColors.primary,
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    locationLabel,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
