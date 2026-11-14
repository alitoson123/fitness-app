import 'dart:convert';
import 'dart:io';

import 'package:fitness_app/core/constant/app_sports.dart';
import 'package:fitness_app/features/notifications/data/helpers/booking_notification_templates.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/intl_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

/// 'table_tennis' -> 'sportTableTennis' (CrossFit is spelled with a capital F).
String _arbKey(String sport) {
  if (sport == 'crossfit') return 'sportCrossFit';
  return 'sport${sport.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join()}';
}

void main() {
  final en = _arb('en');
  final ar = _arb('ar');

  test('notification sport names match the app translations', () {
    expect(
      NotificationDisplayNames.sportKeys.toSet(),
      AppSports.popularSports.map((s) => s.key).toSet(),
    );
    for (final key in NotificationDisplayNames.sportKeys) {
      final name = NotificationDisplayNames.sport(key);
      expect(name.en, en[_arbKey(key)], reason: key);
      expect(name.ar, ar[_arbKey(key)], reason: key);
    }
    expect(
      NotificationDisplayNames.bookingType('monthly').ar,
      ar['monthlyPackageType'],
    );
    expect(
      NotificationDisplayNames.bookingType('session').ar,
      ar['singleSessionType'],
    );
  });

  test('new-booking text has no English words in Arabic', () {
    final text = BookingNotificationTemplates.newBooking(
      traineeName: 'علي',
      sport: 'football',
      bookingType: 'monthly',
    );
    expect(text.bodyAr, contains(ar['sportFootball']));
    expect(text.bodyAr, contains(ar['monthlyPackageType']));
    expect(text.bodyAr, isNot(contains('football')));
    expect(text.bodyEn, 'New booking request from علي for Football (Monthly Plan)');
  });

  test('a custom sport keeps the coach\'s own text', () {
    expect(NotificationDisplayNames.sport('Parkour').ar, 'Parkour');
  });
}
