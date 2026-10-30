import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class CompactRequestActions extends StatelessWidget {
  final bool isActionInProgress;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback? onReschedule;

  const CompactRequestActions({
    super.key,
    required this.isActionInProgress,
    required this.onAccept,
    required this.onReject,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    const amberColor = Color(0xFFD97706);

    if (isActionInProgress) {
      return const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onReject,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                s.rejectRequest,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        if (onReschedule != null) ...[
          SizedBox(width: 6.w),
          Expanded(
            child: OutlinedButton(
              onPressed: onReschedule,
              style: OutlinedButton.styleFrom(
                foregroundColor: amberColor,
                side: const BorderSide(color: amberColor, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  s.rescheduleAction,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
        SizedBox(width: 6.w),
        Expanded(
          child: FilledButton(
            onPressed: onAccept,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                s.acceptRequest,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
