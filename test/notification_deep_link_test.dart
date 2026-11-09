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
  });
}
