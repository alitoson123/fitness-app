import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:fitness_app/features/notifications/data/models/notification_model.dart';
import 'package:fitness_app/features/notifications/data/models/notification_type.dart';
import 'package:fitness_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:fitness_app/features/notifications/presentation/view_model/notifications_cubit/notifications_cubit.dart';
import 'package:fitness_app/features/notifications/presentation/view_model/notifications_cubit/notifications_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _DummyRemoteDataSource implements NotificationsRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeNotificationsRepository extends NotificationsRepository {
  FakeNotificationsRepository()
      : super(remoteDataSource: _DummyRemoteDataSource());

  final StreamController<List<NotificationModel>> streamController =
      StreamController<List<NotificationModel>>.broadcast();

  String? lastMarkedReadId;
  String? lastMarkedAllUid;
  String? lastDeletedId;

  @override
  Stream<List<NotificationModel>> streamNotifications(String recipientUid) =>
      streamController.stream;

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    lastMarkedReadId = notificationId;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String recipientUid) async {
    lastMarkedAllUid = recipientUid;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    lastDeletedId = notificationId;
    return const Right(null);
  }
}

void main() {
  late FakeNotificationsRepository repo;
  late NotificationsCubit cubit;

  final bookingNotif = NotificationModel(
    id: 'n_1',
    recipientUid: 'u1',
    recipientRole: 'trainee',
    senderUid: 'c1',
    senderName: 'Mike',
    type: NotificationType.bookingApproved,
    titleEn: 'Approved',
    titleAr: 'موافقة',
    bodyEn: 'Ok',
    bodyAr: 'تم',
    createdAt: DateTime(2026, 11, 8),
  );

  final adminNotif = NotificationModel(
    id: 'n_2',
    recipientUid: 'u1',
    recipientRole: 'trainee',
    senderUid: 'admin',
    senderName: 'Admin',
    type: NotificationType.adminWarning,
    titleEn: 'Warning',
    titleAr: 'تحذير',
    bodyEn: 'Warn',
    bodyAr: 'تحذير',
    isRead: true,
    createdAt: DateTime(2026, 11, 7),
  );

  setUp(() {
    repo = FakeNotificationsRepository();
    cubit = NotificationsCubit(repository: repo);
  });

  tearDown(() async {
    await cubit.close();
    await repo.streamController.close();
  });

  group('NotificationsCubit Tests (Milestone 10)', () {
    test('initial state has default values', () {
      expect(cubit.state.notifications, isEmpty);
      expect(cubit.state.unreadCount, 0);
      expect(cubit.state.filter, NotificationFilter.all);
    });

    test('listenToNotifications emits items and calculates unreadCount', () async {
      cubit.listenToNotifications('u1');
      repo.streamController.add([bookingNotif, adminNotif]);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.notifications.length, 2);
      expect(cubit.state.unreadCount, 1);
    });

    test('filter correctly filters notifications list', () async {
      cubit.listenToNotifications('u1');
      repo.streamController.add([bookingNotif, adminNotif]);
      await Future<void>.delayed(Duration.zero);

      cubit.setFilter(NotificationFilter.bookings);
      expect(cubit.state.filteredNotifications, [bookingNotif]);
      cubit.setFilter(NotificationFilter.admin);
      expect(cubit.state.filteredNotifications, [adminNotif]);
      cubit.setFilter(NotificationFilter.all);
      expect(cubit.state.filteredNotifications.length, 2);
    });

    test('markAsRead, markAllAsRead, and deleteNotification delegate to repo', () async {
      await cubit.markAsRead('n_1');
      expect(repo.lastMarkedReadId, 'n_1');

      await cubit.markAllAsRead('u1');
      expect(repo.lastMarkedAllUid, 'u1');
      expect(cubit.state.successMessage, 'all_read');

      await cubit.deleteNotification('n_1');
      expect(repo.lastDeletedId, 'n_1');
      expect(cubit.state.successMessage, 'deleted');

      cubit.clearMessages();
      expect(cubit.state.successMessage, isNull);
    });
  });
}
