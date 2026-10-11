import 'package:flutter/material.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'coach_booking_grouper.dart';
import 'coach_date_formatter.dart';

abstract class CoachBookingDateHelper {
  static String formatHumanDate(BuildContext context, String dateStr) =>
      CoachDateFormatter.formatHumanDate(context, dateStr);

  static String formatCountdown(BuildContext context, BookingModel booking) =>
      CoachDateFormatter.formatCountdown(context, booking);

  static BookingModel? getNearestUpcomingSession(
    List<BookingModel> confirmedBookings,
  ) =>
      CoachBookingGrouper.getNearestUpcomingSession(confirmedBookings);

  static double calculateMonthEarnings(List<BookingModel> bookings) =>
      CoachBookingGrouper.calculateMonthEarnings(bookings);

  static List<({DateTime date, int count, bool isToday})> getWeekDays(
    List<BookingModel> bookings,
  ) =>
      CoachBookingGrouper.getWeekDays(bookings);

  static Map<String, List<BookingModel>> groupBookings(
    BuildContext context,
    List<BookingModel> bookings, {
    required bool isPastTab,
  }) =>
      CoachBookingGrouper.groupBookings(
        context,
        bookings,
        isPastTab: isPastTab,
      );
}
