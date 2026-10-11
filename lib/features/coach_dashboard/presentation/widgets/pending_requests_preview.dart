import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'pending_request_compact_card.dart';

class PendingRequestsPreview extends StatelessWidget {
  final List<BookingModel> pendingBookings;
  final String? actionInProgressId;
  final ValueChanged<String> onAccept;
  final void Function(BookingModel booking) onReject;
  final VoidCallback onViewAll;

  const PendingRequestsPreview({
    super.key,
    required this.pendingBookings,
    required this.actionInProgressId,
    required this.onAccept,
    required this.onReject,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPending = pendingBookings.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.pendingRequestsPreview,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            if (pendingBookings.isNotEmpty)
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  s.viewAll,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.flameRed,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        if (topPending.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: 22.r,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    s.noPendingRequestsPreview,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...topPending.map(
            (b) => PendingRequestCompactCard(
              booking: b,
              isActionInProgress: actionInProgressId == b.id,
              onAccept: () => onAccept(b.id),
              onReject: () => onReject(b),
            ),
          ),
      ],
    );
  }
}
