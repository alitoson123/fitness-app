import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class TraineeRejectedBookingSection extends StatefulWidget {
  final String? rejectionReason;
  final VoidCallback onRebook;

  const TraineeRejectedBookingSection({
    super.key,
    required this.rejectionReason,
    required this.onRebook,
  });

  @override
  State<TraineeRejectedBookingSection> createState() =>
      _TraineeRejectedBookingSectionState();
}

class _TraineeRejectedBookingSectionState
    extends State<TraineeRejectedBookingSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final hasReason = widget.rejectionReason?.trim().isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        InkWell(
          onTap: hasReason ? () => setState(() => _isExpanded = !_isExpanded) : null,
          borderRadius: AppRadius.smAll,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: AppRadius.smAll,
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14.r,
                      color: AppColors.error,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        s.statusDeclined,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                    if (hasReason) ...[
                      Text(
                        _isExpanded ? s.tapToHideDetails : s.tapToViewDetails,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.error.withValues(alpha: 0.8),
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 16.r,
                        color: AppColors.error,
                      ),
                    ],
                  ],
                ),
                if (_isExpanded && hasReason) ...[
                  SizedBox(height: 8.h),
                  Divider(
                    height: 1,
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    s.sessionDeclineReason(widget.rejectionReason!),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: widget.onRebook,
            icon: Icon(Icons.refresh_rounded, size: 14.r),
            label: Text(s.bookNewSession, style: TextStyle(fontSize: 12.sp)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ],
    );
  }
}
