import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/services/notification_service/notification_deep_link_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification_model.dart';
import '../helpers/notification_time_helper.dart';
import '../view_model/notifications_cubit/notifications_cubit.dart';
import 'notification_avatar.dart';
import 'notification_banner_detail.dart';

class NotificationItemCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItemCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final cubit = context.read<NotificationsCubit>();

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24.sp),
      ),
      onDismissed: (_) => cubit.deleteNotification(notification.id),
      child: InkWell(
        onTap: () => _handleTap(context, cubit),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark ? AppColors.darkSurface : Colors.white)
                : (isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.primary.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: !notification.isRead
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : (isDark ? AppColors.darkBorder : AppColors.neutral200),
              width: 1.w,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationAvatar(notification: notification),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.localizedTitle(locale),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.neutral900,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          NotificationTimeHelper.formatRelative(
                            context,
                            notification.createdAt,
                          ),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.neutral400,
                          ),
                        ),
                        if (!notification.isRead) ...[
                          SizedBox(width: 6.w),
                          Container(
                            width: 8.w,
                            height: 8.w,
                            margin: EdgeInsets.only(top: 4.h),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.localizedBody(locale),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.neutral500,
                        height: 1.3,
                      ),
                    ),
                    NotificationBannerDetail(notification: notification),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, NotificationsCubit cubit) {
    if (!notification.isRead) {
      cubit.markAsRead(notification.id);
    }

    final payload = Map<String, dynamic>.from(notification.data);
    payload['type'] = notification.type;
    payload['recipientRole'] = notification.recipientRole;
    NotificationDeepLinkHandler.handlePayload(payload);
  }
}
