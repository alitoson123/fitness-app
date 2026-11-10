import '../../../data/models/notification_model.dart';

enum NotificationFilter { all, bookings, admin }

class NotificationsState {
  final List<NotificationModel> notifications;
  final NotificationFilter filter;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const NotificationsState({
    this.notifications = const [],
    this.filter = NotificationFilter.all,
    this.unreadCount = 0,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  List<NotificationModel> get filteredNotifications {
    switch (filter) {
      case NotificationFilter.all:
        return notifications;
      case NotificationFilter.bookings:
        return notifications.where((n) => n.isBookingRelated).toList();
      case NotificationFilter.admin:
        return notifications.where((n) => n.isAdminRelated).toList();
    }
  }

  int get bookingCount =>
      notifications.where((n) => n.isBookingRelated).length;

  int get adminCount =>
      notifications.where((n) => n.isAdminRelated).length;

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    NotificationFilter? filter,
    int? unreadCount,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      filter: filter ?? this.filter,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}
