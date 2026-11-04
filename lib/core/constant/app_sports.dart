import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class AppSportItem {
  final String key;
  final String emoji;

  const AppSportItem({required this.key, required this.emoji});
}

abstract class AppSports {
  static const List<AppSportItem> popularSports = [
    AppSportItem(key: 'football', emoji: '⚽'),
    AppSportItem(key: 'basketball', emoji: '🏀'),
    AppSportItem(key: 'swimming', emoji: '🏊'),
    AppSportItem(key: 'tennis', emoji: '🎾'),
    AppSportItem(key: 'running', emoji: '🏃'),
    AppSportItem(key: 'boxing', emoji: '🥊'),
    AppSportItem(key: 'gym', emoji: '🏋️'),
    AppSportItem(key: 'cycling', emoji: '🚴'),
    AppSportItem(key: 'martial_arts', emoji: '🥋'),
    AppSportItem(key: 'volleyball', emoji: '🏐'),
    AppSportItem(key: 'padel', emoji: '🎾'),
    AppSportItem(key: 'badminton', emoji: '🏸'),
    AppSportItem(key: 'table_tennis', emoji: '🏓'),
    AppSportItem(key: 'crossfit', emoji: '💪'),
    AppSportItem(key: 'handball', emoji: '🤾'),
  ];

  static const String otherKey = 'other';
  static const String otherEmoji = '+';
  static const String customSportEmoji = '🏅';

  static String normalize(String sport) =>
      sport.toLowerCase().replaceAll(' ', '_').trim();

  static bool isPredefined(String sport) {
    final target = normalize(sport);
    return popularSports.any((s) => s.key == target);
  }

  static String getEmoji(String sport) {
    final target = normalize(sport);
    final match = popularSports.where((s) => s.key == target);
    if (match.isNotEmpty) return match.first.emoji;
    if (target == otherKey) return otherEmoji;
    return customSportEmoji;
  }

  static String getLocalizedSportName(BuildContext context, String sport) {
    final s = S.of(context);
    switch (normalize(sport)) {
      case 'gym':
        return s.sportGym;
      case 'football':
        return s.sportFootball;
      case 'boxing':
        return s.sportBoxing;
      case 'swimming':
        return s.sportSwimming;
      case 'basketball':
        return s.sportBasketball;
      case 'tennis':
        return s.sportTennis;
      case 'running':
        return s.sportRunning;
      case 'cycling':
        return s.sportCycling;
      case 'martial_arts':
        return s.sportMartialArts;
      case 'volleyball':
        return s.sportVolleyball;
      case 'padel':
        return s.sportPadel;
      case 'badminton':
        return s.sportBadminton;
      case 'table_tennis':
        return s.sportTableTennis;
      case 'crossfit':
        return s.sportCrossFit;
      case 'handball':
        return s.sportHandball;
      case 'other':
        return s.sportOther;
      default:
        return sport;
    }
  }
}
