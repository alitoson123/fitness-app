import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/notifications/data/models/notification_model.dart';
import 'package:fitness_app/features/notifications/data/models/notification_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationModel Tests (Milestone 9.1)', () {
    final now = DateTime(2026, 11, 7, 12, 0);

    final notification = NotificationModel(
      id: 'notif_1',
      recipientUid: 'coach_123',
      recipientRole: 'coach',
      senderUid: 'trainee_456',
      senderName: 'John Doe',
      type: NotificationType.bookingNew,
      titleEn: 'New Booking Request',
      titleAr: 'طلب حجز جديد',
      bodyEn: 'New booking request from John Doe for boxing (session)',
      bodyAr: 'طلب حجز جديد من John Doe لرياضة boxing (session)',
      data: const {
        'bookingId': 'b_1',
        'priceUSD': 50.0,
        'date': '2026-11-10',
      },
      isRead: false,
      createdAt: now,
    );

    test('serializes to Map correctly with Timestamp', () {
      final map = notification.toMap();

      expect(map['id'], 'notif_1');
      expect(map['recipientUid'], 'coach_123');
      expect(map['recipientRole'], 'coach');
      expect(map['senderUid'], 'trainee_456');
      expect(map['senderName'], 'John Doe');
      expect(map['type'], NotificationType.bookingNew);
      expect(map['titleEn'], 'New Booking Request');
      expect(map['titleAr'], 'طلب حجز جديد');
      expect(map['isRead'], isFalse);
      expect(map['createdAt'], isA<Timestamp>());
      expect(map['data']['bookingId'], 'b_1');
    });

    test('deserializes from Map with Timestamp correctly', () {
      final map = {
        'id': 'notif_2',
        'recipientUid': 'trainee_789',
        'recipientRole': 'trainee',
        'senderUid': 'coach_123',
        'senderName': 'Coach Mike',
        'type': NotificationType.bookingApproved,
        'titleEn': 'Booking Approved',
        'titleAr': 'تمت الموافقة على الحجز',
        'bodyEn': 'Coach Mike approved your booking request for 2026-11-10',
        'bodyAr': 'وافق المدرب Coach Mike على طلب الحجز الخاص بك لتاريخ 2026-11-10',
        'data': {'bookingId': 'b_2'},
        'isRead': true,
        'createdAt': Timestamp.fromDate(now),
      };

      final parsed = NotificationModel.fromMap(map);

      expect(parsed.id, 'notif_2');
      expect(parsed.recipientUid, 'trainee_789');
      expect(parsed.recipientRole, 'trainee');
      expect(parsed.isRead, isTrue);
      expect(parsed.createdAt, now);
      expect(parsed.isBookingRelated, isTrue);
      expect(parsed.isAdminRelated, isFalse);
    });

    test('bilingual localization getters return expected language string', () {
      expect(notification.localizedTitle('en'), 'New Booking Request');
      expect(notification.localizedTitle('ar'), 'طلب حجز جديد');
      expect(
        notification.localizedBody('en'),
        'New booking request from John Doe for boxing (session)',
      );
      expect(
        notification.localizedBody('ar'),
        'طلب حجز جديد من John Doe لرياضة boxing (session)',
      );
    });

    test('type helpers correctly identify booking vs admin notifications', () {
      final adminNotif = NotificationModel(
        id: 'admin_1',
        recipientUid: 'coach_123',
        recipientRole: 'coach',
        senderUid: 'admin',
        senderName: 'Admin',
        type: NotificationType.adminWarning,
        titleEn: 'Warning',
        titleAr: 'تحذير',
        bodyEn: 'Terms of service reminder',
        bodyAr: 'تذكير بشروط الخدمة',
        createdAt: DateTime(2026),
      );

      expect(notification.isBookingRelated, isTrue);
      expect(notification.isAdminRelated, isFalse);
      expect(adminNotif.isBookingRelated, isFalse);
      expect(adminNotif.isAdminRelated, isTrue);
    });

    test('copyWith produces updated immutable instance', () {
      final updated = notification.copyWith(isRead: true);

      expect(updated.isRead, isTrue);
      expect(notification.isRead, isFalse);
      expect(updated.id, notification.id);
    });
  });
}

