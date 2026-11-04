import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/booking_request_cubit/booking_slot_calculator.dart';
import 'booking_summary_row.dart';

class BookingSummaryCard extends StatelessWidget {
  final CoachProfileModel coach;
  final String bookingType;
  final String? sport;
  final String? location;
  final bool isOnline;
  final DateTime? date;
  final String? slot;
  final int sessionsCount;
  final int totalRequiredSessions;
  final String? startDate;
  final String? endDate;
  final int durationMonths;

  const BookingSummaryCard({
    super.key,
    required this.coach,
    this.bookingType = 'session',
    required this.sport,
    this.location,
    this.isOnline = false,
    required this.date,
    required this.slot,
    this.sessionsCount = 0,
    this.totalRequiredSessions = 8,
    this.startDate,
    this.endDate,
    this.durationMonths = 1,
  });

  bool get isMonthly => bookingType == 'monthly';

  @override
  Widget build(BuildContext context) {
    if (date == null || (!isMonthly && slot == null)) {
      return const SizedBox.shrink();
    }
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.primary50.withValues(alpha: 0.5);
    final border = isDark ? AppColors.darkBorder : AppColors.primary100;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final dateFormatted = DateFormat(
      'EEEE, d MMMM',
      Localizations.localeOf(context).languageCode,
    ).format(date!);

    final locationDisplay = isOnline
        ? s.onlineTrainingOption
        : (location?.isNotEmpty == true ? location! : s.notSpecified);

    return Container(
      padding: EdgeInsets.all(14.r),
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
              Icon(Icons.receipt_long_rounded, size: 18.r, color: primary),
              SizedBox(width: 6.w),
              Text(
                isMonthly ? s.monthlyPlanSummaryTitle : s.bookingSummaryTitle,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textPrimary),
              ),
            ],
          ),
          Divider(height: 20.h, color: border),
          BookingSummaryRow(label: s.bookingTypeLabel, value: isMonthly ? s.monthlyPackageType : s.singleSessionType, labelColor: textSecondary, valueColor: textPrimary),
          SizedBox(height: 8.h),
          BookingSummaryRow(label: s.selectedSportLabel, value: sport ?? '', labelColor: textSecondary, valueColor: textPrimary),
          SizedBox(height: 8.h),
          BookingSummaryRow(label: s.trainingLocationLabel, value: locationDisplay, labelColor: textSecondary, valueColor: primary, isBold: true),
          SizedBox(height: 8.h),
          BookingSummaryRow(label: isMonthly ? s.packageStartDateLabel : s.selectedDateLabel, value: startDate ?? dateFormatted, labelColor: textSecondary, valueColor: textPrimary),
          SizedBox(height: 8.h),
          if (!isMonthly && slot != null) ...[
            BookingSummaryRow(
              label: s.selectedTimeLabel,
              value: '$slot - ${BookingSlotCalculator.computeEndTime(slot!, coach.sessionDurationMinutes)}',
              labelColor: textSecondary,
              valueColor: textPrimary,
            ),
            SizedBox(height: 8.h),
          ],
          if (isMonthly) ...[
            BookingSummaryRow(label: s.durationMonthsLabel, value: s.oneMonthDuration, labelColor: textSecondary, valueColor: textPrimary),
            SizedBox(height: 8.h),
            BookingSummaryRow(
              label: s.selectedSessionsListTitle(sessionsCount, totalRequiredSessions),
              value: '$sessionsCount / $totalRequiredSessions',
              labelColor: textSecondary,
              valueColor: sessionsCount == totalRequiredSessions ? Colors.green : primary,
              isBold: true,
            ),
            SizedBox(height: 8.h),
          ],
          BookingSummaryRow(
            label: isMonthly ? s.totalMonthlyPrice : s.totalSessionPrice,
            value: isMonthly
                ? '\$${(coach.monthlyPriceUSD * durationMonths).toStringAsFixed(0)} USD'
                : '\$${coach.sessionPriceUSD.toStringAsFixed(0)} USD',
            labelColor: textSecondary,
            valueColor: primary,
            isBold: true,
          ),
        ],
      ),
    );
  }
}
