import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/notification_model.dart';
import 'empty_notifications_view.dart';
import 'notification_item_card.dart';

class NotificationsListBody extends StatelessWidget {
  final List<NotificationModel> notifications;
  final bool isFiltered;
  final Future<void> Function()? onRefresh;

  const NotificationsListBody({
    super.key,
    required this.notifications,
    required this.isFiltered,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return EmptyNotificationsView(isFiltered: isFiltered);
    }

    final listView = ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: notifications.length,
      separatorBuilder: (_, _) => SizedBox(height: 4.h),
      itemBuilder: (context, index) {
        return NotificationItemCard(
          notification: notifications[index],
        );
      },
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}
