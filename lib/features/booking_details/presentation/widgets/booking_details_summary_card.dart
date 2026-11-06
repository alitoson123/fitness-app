import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class BookingDetailsSummaryCard extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsSummaryCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final planLabel = booking.isMonthly
        ? '${s.monthlyPackageType} (${booking.sessions.length} ${s.sessionsSchedule})'
        : s.singleSessionPlan;

    final dateTimeLabel = booking.isMonthly
        ? booking.date
        : '${booking.date} • ${booking.startTime} - ${booking.endTime}';

    final locationLabel = booking.isOnline
        ? s.onlineTrainingOption
        : (booking.trainingLocation.isNotEmpty
            ? booking.trainingLocation
            : s.physicalLocations);

    return Container(
      padding: EdgeInsets.all(14.r),
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
          Text(
            s.bookingOverview,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 10.h),
          _buildRow(
            icon: Icons.calendar_month_rounded,
            title: dateTimeLabel,
            subtitle: planLabel,
            isDark: isDark,
            textSecondary: textSecondary,
          ),
          SizedBox(height: 10.h),
          _buildRow(
            icon: booking.isOnline
                ? Icons.laptop_chromebook_rounded
                : Icons.location_on_rounded,
            title: locationLabel,
            subtitle: booking.isOnline ? s.onlineAvailableBadge : s.trainingLocationLabel,
            isDark: isDark,
            textSecondary: textSecondary,
          ),
          SizedBox(height: 10.h),
          _buildRow(
            icon: Icons.payments_rounded,
            title: '${booking.price.toInt()} ${booking.currency}',
            subtitle: booking.isMonthly ? s.monthlyPackageType : s.singleSessionPlan,
            isDark: isDark,
            textSecondary: textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color textSecondary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.r, color: AppColors.primary),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11.sp, color: textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
