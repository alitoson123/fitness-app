import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class BookingDetailsNotesCard extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsNotesCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final hasNotes = booking.notes.trim().isNotEmpty;
    final hasRejection = booking.status == 'rejected' &&
        booking.rejectionReason?.trim().isNotEmpty == true;
    final hasCancellation = booking.status == 'cancelled' &&
        booking.cancellationReason?.trim().isNotEmpty == true;

    if (!hasNotes && !hasRejection && !hasCancellation) {
      return const SizedBox.shrink();
    }

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
          if (hasNotes) ...[
            Text(
              s.clientNotesTitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: textSecondary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              booking.notes,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ],
          if (hasRejection) ...[
            if (hasNotes) SizedBox(height: 12.h),
            Text(
              s.rejectionReasonTitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              booking.rejectionReason!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.error,
              ),
            ),
          ],
          if (hasCancellation) ...[
            if (hasNotes || hasRejection) SizedBox(height: 12.h),
            Text(
              s.cancellationReasonTitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              BookingModel.displayCancellationReason(
                booking.cancellationReason!,
                S.of(context),
              ),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

