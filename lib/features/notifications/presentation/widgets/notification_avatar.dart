import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/notification_type.dart';

class NotificationAvatar extends StatelessWidget {
  final NotificationModel notification;

  const NotificationAvatar({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getIndicatorStyle(notification.type);

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5.w),
      ),
      child: Center(
        child: Icon(icon, size: 22.sp, color: color),
      ),
    );
  }

  (IconData, Color) _getIndicatorStyle(String type) {
    switch (type) {
      case NotificationType.bookingApproved:
      case NotificationType.bookingRescheduleAccepted:
      case NotificationType.bookingMonthlySessionRescheduleAccepted:
      case NotificationType.bookingMonthlySessionCompleted:
      case NotificationType.coachProfileApproved:
        return (Icons.check_circle_rounded, AppColors.success);

      case NotificationType.bookingRejected:
      case NotificationType.bookingRescheduleDeclined:
      case NotificationType.bookingMonthlySessionRescheduleDeclined:
      case NotificationType.bookingCancelled:
      case NotificationType.bookingCancelledAccountDeleted:
      case NotificationType.coachProfileRejected:
        return (Icons.cancel_rounded, AppColors.error);

      case NotificationType.adminWarning:
        return (Icons.warning_amber_rounded, AppColors.warning);

      case NotificationType.accountSuspended:
        return (Icons.block_rounded, AppColors.error);

      case NotificationType.coachVerificationSubmitted:
        return (Icons.verified_user_rounded, AppColors.secondary);

      case NotificationType.bookingNew:
      case NotificationType.bookingRescheduleProposed:
      case NotificationType.bookingMonthlySessionRescheduleProposed:
      default:
        return (Icons.calendar_today_rounded, AppColors.primary);
    }
  }
}
