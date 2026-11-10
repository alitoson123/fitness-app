import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../generated/l10n.dart';

abstract class NotificationTimeHelper {
  static String formatRelative(BuildContext context, DateTime dateTime) {
    final s = S.of(context);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return s.timeJustNow;
    } else if (difference.inMinutes < 60) {
      return s.timeMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return s.timeHoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return s.timeDaysAgo(difference.inDays);
    } else {
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat('d MMM', locale).format(dateTime);
    }
  }
}
