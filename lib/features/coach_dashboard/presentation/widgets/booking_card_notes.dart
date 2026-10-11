import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class BookingCardNotes extends StatelessWidget {
  final String? notes;
  final String? rejectionReason;
  final bool isDark;

  const BookingCardNotes({
    super.key,
    this.notes,
    this.rejectionReason,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notes?.isNotEmpty == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground.withValues(alpha: 0.6)
                  : AppColors.backgroundSecondary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6.r),
              border: Border(
                left: BorderSide(
                  color: AppColors.flameRed.withValues(alpha: 0.4),
                  width: 2.w,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.notes_rounded,
                  size: 12.r,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '"$notes"',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        if (rejectionReason?.isNotEmpty == true) ...[
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              s.sessionDeclineReason(rejectionReason!),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.error,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
