import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/navigator/app_routes.dart';
import 'package:fitness_app/core/services/notification_service/notification_deep_link_handler.dart';
import 'package:fitness_app/features/booking_details/presentation/view_model/booking_details_args.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/notifications/data/models/notification_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Notification Push & Deep Link Payload Contracts (Milestone 9.3)', () {
    test('FCM token payload schema validation for Firestore sync', () {
      final tokenPayload = {
        'token': 'fcm_sample_token_xyz',
        'uid': 'user_abc',
        'platform': 'android',
        'updatedAt': '2026-11-07T12:00:00Z',
      };

      expect(tokenPayload['token'], isNotEmpty);
      expect(tokenPayload['uid'], 'user_abc');
      expect(tokenPayload['platform'], 'android');
    });

    test(
      'Booking notification deep link payload contains bookingId and type',
      () {
        final payload = {
          'bookingId': 'b_200',
          'type': NotificationType.bookingApproved,
          'recipientRole': 'trainee',
        };

        expect(payload['bookingId'], 'b_200');
        expect(NotificationType.isBookingRelated(payload['type']!), isTrue);
      },
    );

    test(
      'Coach verification notification payload routes to verification or dashboard',
      () {
        final verificationPayload = {
          'type': NotificationType.coachVerificationSubmitted,
          'coachUid': 'coach_123',
        };
        final approvalPayload = {
          'type': NotificationType.coachProfileApproved,
          'coachUid': 'coach_123',
        };

        expect(
          NotificationType.isAdminRelated(verificationPayload['type']!),
          isTrue,
        );
        expect(
          NotificationType.isAdminRelated(approvalPayload['type']!),
          isTrue,
        );
      },
    );

    test('Admin warning and suspension payloads contain status and reason', () {
      final suspensionPayload = {
        'type': NotificationType.accountSuspended,
        'status': 'suspended',
        'reason': 'Chargeback fraud',
      };

      expect(suspensionPayload['status'], 'suspended');
      expect(suspensionPayload['reason'], 'Chargeback fraud');
      expect(
        NotificationType.isAdminRelated(suspensionPayload['type']!),
        isTrue,
      );
    });

    test('handlePayloadWith pushes BookingDetailsView for signed-in user', () async {
      final pushed = <(String, Object?)>[];
      const booking = BookingModel(
        id: 'b_200',
        coachUid: 'coach_1',
        coachName: 'Coach Mike',
        traineeUid: 'trainee_1',
        traineeName: 'Sara',
        sport: 'fitness',
        bookingType: 'session',
        date: '2026-11-12',
        startTime: '10:00',
        endTime: '11:00',
        price: 40,
      );

      await NotificationDeepLinkHandler.handlePayloadWith(
        data: {'bookingId': 'b_200', 'type': NotificationType.bookingApproved},
        currentUid: 'coach_1',
        fetchBooking: (_) async => const Right(booking),
        pushRoute: (route, {extra}) => pushed.add((route, extra)),
        goRoute: (_) {},
      );

      expect(pushed.length, 1);
      expect(pushed.first.$1, AppRoutes.bookingDetails);
      final args = pushed.first.$2 as BookingDetailsArgs;
      expect(args.booking.id, 'b_200');
      expect(args.isCoach, isTrue);
    });

    test('handlePayloadWith ignores deep links when signed out', () async {
      final pushed = <String>[];
      await NotificationDeepLinkHandler.handlePayloadWith(
        data: {'bookingId': 'b_200'},
        currentUid: null,
        fetchBooking: (_) async => throw StateError('should not fetch'),
        pushRoute: (route, {extra}) => pushed.add(route),
        goRoute: (_) {},
      );
      expect(pushed, isEmpty);
    });

    test('from the inbox, a booking that cannot load shows a message and '
        'stays on the screen', () async {
      final went = <String>[];
      final messages = <String>[];
      await NotificationDeepLinkHandler.handlePayloadWith(
        data: {'bookingId': 'b_200', 'recipientRole': 'trainee'},
        currentUid: 'trainee_1',
        fetchBooking: (_) async =>
            Left(ServerFailure(errorMessage: 'No connection')),
        pushRoute: (route, {extra}) => went.add(route),
        goRoute: went.add,
        onBookingLoadFailed: messages.add,
      );
      expect(went, isEmpty);
      expect(messages, ['No connection']);
    });

    test('from a push tap (no message callback), a failed booking load '
        'still falls back to home', () async {
      final went = <String>[];
      await NotificationDeepLinkHandler.handlePayloadWith(
        data: {'bookingId': 'b_200', 'recipientRole': 'trainee'},
        currentUid: 'trainee_1',
        fetchBooking: (_) async =>
            Left(ServerFailure(errorMessage: 'No connection')),
        pushRoute: (route, {extra}) {},
        goRoute: went.add,
      );
      expect(went, [AppRoutes.traineeHome]);
    });
  });
}
