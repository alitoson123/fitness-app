import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import '../models/booking_model.dart';

class BookingRequestRemoteDataSource {
  final FirestoreService firestoreService;

  BookingRequestRemoteDataSource({required this.firestoreService});

  /// Busy start times for [coachUid] on [date] (`YYYY-MM-DD`).
  ///
  /// Reads the public `coach_busy_slots/{coachUid}` document, which a Cloud
  /// Function (`onBookingWritten`) rebuilds from the coach's bookings. The app
  /// no longer reads other users' bookings, so the `bookings` collection can
  /// stay private to each booking's coach and trainee.
  Future<List<String>> getBookedSlots({
    required String coachUid,
    required String date,
  }) async {
    LoggerService.info(
      'Fetching busy slots for coach: $coachUid on $date',
      tag: 'BookingRequestRemoteDataSource',
    );

    final doc = await firestoreService.getDoc(
      collection: AppConstants.coachBusySlotsCollection,
      docId: coachUid,
    );
    final slots = doc.data()?['slots'];
    if (slots is! Map) return const [];
    final forDate = slots[date];
    if (forDate is! List) return const [];
    return forDate.whereType<String>().where((s) => s.isNotEmpty).toList();
  }

  Future<String> createBooking(BookingModel booking) async {
    LoggerService.info(
      'Creating remote booking request for coach: ${booking.coachUid} (type: ${booking.bookingType}, sessions: ${booking.sessions.length})',
      tag: 'BookingRequestRemoteDataSource',
    );

    final docRef = FirebaseFirestore.instance
        .collection(AppConstants.bookingsCollection)
        .doc();
    final bookingId = docRef.id;

    final fullBooking = booking.copyWith(id: bookingId);

    await firestoreService.setData(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
      data: fullBooking.toMap(),
    );

    return bookingId;
  }
}
