import '../../../booking_request/data/models/booking_model.dart';

class BookingDetailsArgs {
  final BookingModel booking;
  final bool isCoach;

  const BookingDetailsArgs({
    required this.booking,
    required this.isCoach,
  });
}

