import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/notification_service/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubFirestore implements FirestoreService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group(
    'NotificationService Deduplication & Cold-Start Queue (Milestone 11.4)',
    () {
      late List<({int id, String title, String body, String? tag})> displayed;
      late List<Map<String, dynamic>> dispatchedDeepLinks;
      late NotificationService service;

      setUp(() {
        displayed = [];
        dispatchedDeepLinks = [];
        service = NotificationService(
          firestoreService: _StubFirestore(),
          displayOverride:
              ({
                required int id,
                required String title,
                required String body,
                String? tag,
                String? payload,
              }) async {
                displayed.add((id: id, title: title, body: body, tag: tag));
              },
          deepLinkDispatcher: (data) async {
            dispatchedDeepLinks.add(data);
          },
        );
      });

      test(
        'deduplicates foreground FCM pushes sharing the same notificationId',
        () async {
          const msg1 = RemoteMessage(
            data: {'notificationId': 'notif_99', 'bookingId': 'b_1'},
            notification: RemoteNotification(
              title: 'Approved',
              body: 'Your booking is confirmed',
            ),
          );
          const msg2 = RemoteMessage(
            data: {'notificationId': 'notif_99', 'bookingId': 'b_1'},
            notification: RemoteNotification(
              title: 'Approved',
              body: 'Your booking is confirmed',
            ),
          );

          await service.handleForegroundMessage(msg1);
          await service.handleForegroundMessage(msg2);

          expect(displayed.length, 1);
          expect(displayed.first.tag, 'notif_99');
          expect(service.hasDelivered('notif_99'), isTrue);
        },
      );

      test(
        'suppresses foreground banners when notificationsEnabled is false',
        () async {
          service.updatePreferences(notificationsEnabled: false);
          const msg = RemoteMessage(
            data: {'notificationId': 'notif_muted'},
            notification: RemoteNotification(title: 'Alert', body: 'Muted'),
          );

          await service.handleForegroundMessage(msg);
          await service.showNotification(
            id: 1,
            title: 'Fallback',
            body: 'Muted',
          );

          expect(displayed, isEmpty);
        },
      );

      test(
        'queues cold-start payload until consumePendingDeepLink() is called after splash',
        () async {
          final coldPayload = {
            'bookingId': 'b_777',
            'type': 'booking_approved',
          };
          service.queuePendingDeepLink(coldPayload);

          expect(service.isRouterReady, isFalse);
          expect(service.pendingInitialPayload, coldPayload);
          expect(dispatchedDeepLinks, isEmpty);

          await service.consumePendingDeepLink();

          expect(service.isRouterReady, isTrue);
          expect(service.pendingInitialPayload, isNull);
          expect(dispatchedDeepLinks, [coldPayload]);

          // Consuming twice does not re-dispatch
          await service.consumePendingDeepLink();
          expect(dispatchedDeepLinks.length, 1);
        },
      );

      test(
        'clearPendingDeepLink discards stale payload when signed out',
        () async {
          service.queuePendingDeepLink({'bookingId': 'b_stale'});
          service.clearPendingDeepLink();

          expect(service.isRouterReady, isTrue);
          expect(service.pendingInitialPayload, isNull);
          await service.consumePendingDeepLink();
          expect(dispatchedDeepLinks, isEmpty);
        },
      );
    },
  );
}
