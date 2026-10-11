import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../helpers/coach_booking_date_helper.dart';
import 'booking_card_actions.dart';
import 'booking_card_header.dart';
import 'booking_card_info.dart';
import 'booking_card_notes.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isActionInProgress;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const BookingCard({
    super.key,
    required this.booking,
    this.isActionInProgress = false,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPending = booking.status == 'pending';
    final isHistory =
        booking.status == 'completed' || booking.status == 'rejected';
    final dateFormatted = CoachBookingDateHelper.formatHumanDate(
      context,
      booking.date,
    );

    return Opacity(
      opacity: isHistory ? 0.90 : 1.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
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
            BookingCardHeader(booking: booking, isDark: isDark),
            SizedBox(height: 10.h),
            BookingCardInfo(
              dateFormatted: dateFormatted,
              startTime: booking.startTime,
              endTime: booking.endTime,
              isDark: isDark,
            ),
            if (booking.notes.isNotEmpty ||
                (booking.status == 'rejected' &&
                    booking.rejectionReason?.isNotEmpty == true)) ...[
              SizedBox(height: 8.h),
              BookingCardNotes(
                notes: booking.notes,
                rejectionReason: booking.rejectionReason,
                isDark: isDark,
              ),
            ],
            if (isPending) ...[
              SizedBox(height: 12.h),
              BookingCardActions(
                isActionInProgress: isActionInProgress,
                onAccept: onAccept,
                onReject: onReject,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
