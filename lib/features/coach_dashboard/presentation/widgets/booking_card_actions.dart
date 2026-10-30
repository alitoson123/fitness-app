import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class BookingCardActions extends StatelessWidget {
  final bool isActionInProgress;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onReschedule;

  const BookingCardActions({
    super.key,
    required this.isActionInProgress,
    this.onAccept,
    this.onReject,
    this.onReschedule,
  });

  Widget _buildReject(S s) {
    return OutlinedButton.icon(
      onPressed: onReject,
      icon: Icon(Icons.close_rounded, size: 14.r),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(s.rejectRequest, style: TextStyle(fontSize: 12.sp)),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: const BorderSide(color: AppColors.error),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      ),
    );
  }

  Widget _buildReschedule(S s) {
    const amberColor = Color(0xFFD97706);
    return OutlinedButton.icon(
      onPressed: onReschedule,
      icon: Icon(Icons.schedule_rounded, size: 14.r),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(s.rescheduleAction, style: TextStyle(fontSize: 12.sp)),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: amberColor,
        side: const BorderSide(color: amberColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      ),
    );
  }

  Widget _buildAccept(S s) {
    return FilledButton.icon(
      onPressed: onAccept,
      icon: Icon(Icons.check_rounded, size: 14.r),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(s.acceptRequest, style: TextStyle(fontSize: 12.sp)),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      ),
    );
  }

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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (onReschedule == null) {
          return Row(
            children: [
              Expanded(child: _buildReject(s)),
              SizedBox(width: 8.w),
              Expanded(child: _buildAccept(s)),
            ],
          );
        }

        if (constraints.maxWidth >= 380) {
          return Row(
            children: [
              Expanded(child: _buildReject(s)),
              SizedBox(width: 6.w),
              Expanded(child: _buildReschedule(s)),
              SizedBox(width: 6.w),
              Expanded(child: _buildAccept(s)),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: _buildReject(s)),
                SizedBox(width: 8.w),
                Expanded(child: _buildReschedule(s)),
              ],
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: _buildAccept(s),
            ),
          ],
        );
      },
    );
  }
}
