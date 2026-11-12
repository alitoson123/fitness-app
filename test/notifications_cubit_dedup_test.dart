import 'dart:async';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/notification_service/notification_service.dart';
import 'package:fitness_app/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:fitness_app/features/notifications/data/models/notification_model.dart';
import 'package:fitness_app/features/notifications/data/models/notification_type.dart';
import 'package:fitness_app/features/notifications/data/repos/notifications_repo.dart';
import 'package:fitness_app/features/notifications/presentation/view_model/notifications_cubit/notifications_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _DummyRemote implements NotificationsRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DummyFirestore implements FirestoreService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeRepo extends NotificationsRepository {
  final controller = StreamController<List<NotificationModel>>.broadcast();
  _FakeRepo() : super(remoteDataSource: _DummyRemote());
  @override
  Stream<List<NotificationModel>> streamNotifications(String uid) =>
      controller.stream;
}

void main() {
  group('NotificationsCubit Zero-Duplicate Fallback Tests (Milestone 11.4)', () {
    late _FakeRepo repo;
    late List<String> displayedTitles;
    late NotificationService service;
    late NotificationsCubit cubit;

    NotificationModel makeNotif(String id, {String pushStatus = 'pending'}) {
      return NotificationModel(
        id: id,
        recipientUid: 'u1',
        recipientRole: 'trainee',
        senderUid: 'c1',
        senderName: 'Coach',
        type: NotificationType.bookingApproved,
        titleEn: 'Approved $id',
        titleAr: 'موافقة $id',
        bodyEn: 'Body EN',
        bodyAr: 'Body AR',
        pushStatus: pushStatus,
        createdAt: DateTime(2026, 11, 10),
      );
    }

    setUp(() {
      repo = _FakeRepo();
      displayedTitles = [];
      service = NotificationService(
        firestoreService: _DummyFirestore(),
        displayOverride:
            ({
              required int id,
              required String title,
              required String body,
              String? tag,
              String? payload,
            }) async {
              displayedTitles.add(title);
            },
      );
      cubit = NotificationsCubit(
        repository: repo,
        notificationService: service,
      );
    });

    tearDown(() async {
      await cubit.close();
      await repo.controller.close();
    });

    test(
      'skips local fallback when pushStatus is sent or already delivered by FCM',
      () async {
        cubit.listenToNotifications('u1');
        repo.controller.add([makeNotif('n_init')]);
        await Future<void>.delayed(Duration.zero);

        // Mark n_fcm as already delivered by FCM foreground listener
        await service.showNotification(
          id: 1,
          notificationId: 'n_fcm',
          title: 'FCM',
          body: 'b',
        );
        displayedTitles.clear();

        repo.controller.add([
          makeNotif('n_init'),
          makeNotif('n_fcm'),
          makeNotif('n_cloud', pushStatus: 'sent'),
          makeNotif('n_local_fallback', pushStatus: 'pending'),
        ]);
        await Future<void>.delayed(Duration.zero);

        expect(displayedTitles, ['Approved n_local_fallback']);
      },
    );

    test('respects languageCode and notificationsEnabled preference', () async {
      service.updatePreferences(languageCode: 'ar', notificationsEnabled: true);
      cubit.listenToNotifications('u1');
      repo.controller.add([]);
      await Future<void>.delayed(Duration.zero);

      repo.controller.add([makeNotif('n_ar')]);
      await Future<void>.delayed(Duration.zero);
      expect(displayedTitles, ['موافقة n_ar']);

      service.updatePreferences(notificationsEnabled: false);
      repo.controller.add([makeNotif('n_ar'), makeNotif('n_muted')]);
      await Future<void>.delayed(Duration.zero);
      expect(displayedTitles, ['موافقة n_ar']);
    });
  });
}
