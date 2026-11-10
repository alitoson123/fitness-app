import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/notification_service/notification_service.dart';
import '../../../data/repos/notifications_repo.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;
  final NotificationService? notificationService;
  StreamSubscription? _subscription;
  Set<String> _knownIds = {};
  bool _isInitialLoad = true;

  NotificationsCubit({
    required this.repository,
    this.notificationService,
  }) : super(const NotificationsState());

  void listenToNotifications(String uid) {
    if (uid.isEmpty) return;
    _subscription?.cancel();
    _isInitialLoad = true;
    _knownIds = {};
    emit(state.copyWith(isLoading: true, clearMessages: true));

    _subscription = repository.streamNotifications(uid).listen(
      (items) {
        if (!_isInitialLoad && notificationService != null) {
          for (final item in items) {
            if (!_knownIds.contains(item.id) && !item.isRead) {
              final payload = Map<String, dynamic>.from(item.data);
              payload['type'] = item.type;
              payload['recipientRole'] = item.recipientRole;
              notificationService!.showNotification(
                id: item.id.hashCode,
                title: item.titleAr.isNotEmpty ? item.titleAr : item.titleEn,
                body: item.bodyAr.isNotEmpty ? item.bodyAr : item.bodyEn,
                payload: payload,
              );
            }
          }
        }
        _knownIds = items.map((n) => n.id).toSet();
        _isInitialLoad = false;

        final unread = items.where((n) => !n.isRead).length;
        emit(state.copyWith(
          notifications: items,
          unreadCount: unread,
          isLoading: false,
        ));
      },
      onError: (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      },
    );
  }

  void setFilter(NotificationFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  Future<void> markAsRead(String notificationId) async {
    final res = await repository.markAsRead(notificationId);
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.errorMessage)),
      (_) {},
    );
  }

  Future<void> markAllAsRead(String uid) async {
    if (uid.isEmpty) return;
    final res = await repository.markAllAsRead(uid);
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.errorMessage)),
      (_) {
        emit(state.copyWith(successMessage: 'all_read'));
      },
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final res = await repository.deleteNotification(notificationId);
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.errorMessage)),
      (_) {
        emit(state.copyWith(successMessage: 'deleted'));
      },
    );
  }

  void clearMessages() {
    emit(state.copyWith(clearMessages: true));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
