import 'training_insights_calculator.dart';

abstract class TrainingPeriodNavigator {
  static bool canGoForward(TrainingPeriod period, DateTime date) {
    final now = DateTime.now();
    switch (period) {
      case TrainingPeriod.day:
        final currentDay = DateTime(date.year, date.month, date.day);
        final today = DateTime(now.year, now.month, now.day);
        return currentDay.isBefore(today);
      case TrainingPeriod.month:
        final currentMonth = DateTime(date.year, date.month);
        final thisMonth = DateTime(now.year, now.month);
        return currentMonth.isBefore(thisMonth);
      case TrainingPeriod.year:
        return date.year < now.year;
    }
  }

  static DateTime computePreviousDate(TrainingPeriod period, DateTime current) {
    switch (period) {
      case TrainingPeriod.day:
        return current.subtract(const Duration(days: 1));
      case TrainingPeriod.month:
        return DateTime(current.year, current.month - 1, current.day);
      case TrainingPeriod.year:
        return DateTime(current.year - 1, current.month, current.day);
    }
  }

  static DateTime computeNextDate(TrainingPeriod period, DateTime current) {
    switch (period) {
      case TrainingPeriod.day:
        return current.add(const Duration(days: 1));
      case TrainingPeriod.month:
        return DateTime(current.year, current.month + 1, current.day);
      case TrainingPeriod.year:
        return DateTime(current.year + 1, current.month, current.day);
    }
  }
}
