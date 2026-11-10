import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/notification_type.dart';

class NotificationBannerDetail extends StatelessWidget {
  final NotificationModel notification;

  const NotificationBannerDetail({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final data = notification.data;
    if (data.isEmpty) return const SizedBox.shrink();

    final rejectionReason =
        data['rejectionReason'] as String? ??
        (notification.type == NotificationType.bookingRejected
            ? data['reason'] as String?
            : null);
    final rescheduleReason =
        data['rescheduleReason'] as String? ?? data['declineReason'] as String?;
    final proposedDate = data['proposedDate'] as String?;
    final proposedTime = data['proposedTime'] as String?;
    final adminMessage =
        data['adminMessage'] as String? ??
        (notification.isAdminRelated ? data['reason'] as String? : null);

    if (rejectionReason != null && rejectionReason.isNotEmpty) {
      return _buildBanner(
        icon: Icons.cancel_outlined,
        text: rejectionReason,
        backgroundColor: AppColors.error.withValues(alpha: 0.12),
        textColor: AppColors.error,
      );
    }

    if (rescheduleReason != null && rescheduleReason.isNotEmpty) {
      return _buildBanner(
        icon: Icons.schedule_rounded,
        text: rescheduleReason,
        backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
        textColor: AppColors.secondary,
      );
    }

    if (proposedDate != null && proposedDate.isNotEmpty) {
      final timeStr = proposedTime != null ? ' - $proposedTime' : '';
      return _buildBanner(
        icon: Icons.update_rounded,
        text: '$proposedDate$timeStr',
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        textColor: AppColors.primary,
      );
    }

    if (adminMessage != null && adminMessage.isNotEmpty) {
      return _buildBanner(
        icon: Icons.warning_amber_rounded,
        text: adminMessage,
        backgroundColor: AppColors.warning.withValues(alpha: 0.12),
        textColor: AppColors.warning,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBanner({
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14.sp, color: textColor),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
