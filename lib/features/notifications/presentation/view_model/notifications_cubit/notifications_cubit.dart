import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/app_error_messages.dart';
import '../../../../../core/services/notification_service/notification_service.dart';
import '../../../data/models/notification_model.dart';
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
          _dispatchForegroundFallback(items);
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
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: AppErrorMessages.from(e),
          ),
        );
      },
    );
  }

  void _dispatchForegroundFallback(List<NotificationModel> items) {
    final service = notificationService;
    if (service == null || !service.notificationsEnabled) return;

    for (final item in items) {
      final isNew = !_knownIds.contains(item.id) && !item.isRead;
      final alreadyHandledByCloud =
          item.pushStatus == 'sent' ||
          item.data['pushStatus'] == 'sent' ||
          service.hasDelivered(item.id);
      if (!isNew || alreadyHandledByCloud) continue;

      final lang = service.languageCode;
      final title = item.localizedTitle(lang).isNotEmpty
          ? item.localizedTitle(lang)
          : item.titleEn;
      final body = item.localizedBody(lang).isNotEmpty
          ? item.localizedBody(lang)
          : item.bodyEn;
      final payload = Map<String, dynamic>.from(item.data)
        ..['notificationId'] = item.id
        ..['type'] = item.type
        ..['recipientRole'] = item.recipientRole;

      service.showNotification(
        id: item.id.hashCode,
        notificationId: item.id,
        title: title,
        body: body,
        payload: payload,
      );
    }
  }

  void setFilter(NotificationFilter filter) =>
      emit(state.copyWith(filter: filter));

  Future<void> markAsRead(String notificationId) async {
    final res = await repository.markAsRead(notificationId);
    res.fold((f) => emit(state.copyWith(errorMessage: f.errorMessage)), (_) {});
  }

  Future<void> markAllAsRead(String uid) async {
    if (uid.isEmpty) return;
    final res = await repository.markAllAsRead(uid);
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.errorMessage)),
      (_) => emit(state.copyWith(successMessage: 'all_read')),
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final res = await repository.deleteNotification(notificationId);
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.errorMessage)),
      (_) => emit(state.copyWith(successMessage: 'deleted')),
    );
  }

  void clearMessages() => emit(state.copyWith(clearMessages: true));

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
