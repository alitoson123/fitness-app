import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/booking_request_cubit/booking_slot_calculator.dart';

class BookingSummaryCard extends StatelessWidget {
  final CoachProfileModel coach;
  final String? sport;
  final DateTime? date;
  final String? slot;

  const BookingSummaryCard({
    super.key,
    required this.coach,
    required this.sport,
    required this.date,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    if (slot == null || date == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.primary50.withValues(alpha: 0.5);
    final border = isDark ? AppColors.darkBorder : AppColors.primary100;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final dateFormatted = DateFormat('EEEE, d MMMM', Localizations.localeOf(context).languageCode).format(date!);
    final endTime = BookingSlotCalculator.computeEndTime(slot!, coach.sessionDurationMinutes);

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
                S.of(context).bookingSummaryTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: border),
          _buildRow(S.of(context).selectedSportLabel, sport ?? '', textSecondary, textPrimary),
          SizedBox(height: 8.h),
          _buildRow(S.of(context).selectedDateLabel, dateFormatted, textSecondary, textPrimary),
          SizedBox(height: 8.h),
          _buildRow(S.of(context).selectedTimeLabel, '$slot - $endTime', textSecondary, textPrimary),
          SizedBox(height: 8.h),
          _buildRow(
            S.of(context).totalSessionPrice,
            '${coach.sessionPrice.toStringAsFixed(0)} ${coach.currency}',
            textSecondary,
            primary,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: labelColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
