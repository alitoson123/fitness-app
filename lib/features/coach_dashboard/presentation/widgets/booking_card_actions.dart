import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class BookingCardActions extends StatelessWidget {
  final bool isActionInProgress;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const BookingCardActions({
    super.key,
    required this.isActionInProgress,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (isActionInProgress) {
      return const Center(
        child: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onReject,
            icon: Icon(Icons.close_rounded, size: 14.r),
            label: Text(s.rejectRequest, style: TextStyle(fontSize: 12.sp)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: FilledButton.icon(
            onPressed: onAccept,
            icon: Icon(Icons.check_rounded, size: 14.r),
            label: Text(s.acceptRequest, style: TextStyle(fontSize: 12.sp)),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ],
    );
  }
}
