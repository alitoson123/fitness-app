import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import '../models/booking_model.dart';

class BookingRequestRemoteDataSource {
  final FirestoreService firestoreService;

  BookingRequestRemoteDataSource({required this.firestoreService});

  Future<List<String>> getBookedSlots({
    required String coachUid,
    required String date,
  }) async {
    LoggerService.info(
      'Fetching remote booked slots for coach: $coachUid on $date',
      tag: 'BookingRequestRemoteDataSource',
    );

    final snapshot = await firestoreService.getCollection(
      collection: AppConstants.bookingsCollection,
      queryBuilder: (query) => query
          .where('coachUid', isEqualTo: coachUid)
          .where('date', isEqualTo: date),
    );

    final bookedSlots = <String>[];
    for (final doc in snapshot.docs) {

      final data = doc.data();

      final status = data['status'] as String? ?? '';

      if (status != 'rejected') {

        final slot = data['startTime'] as String?;

        if (slot != null && slot.isNotEmpty) {

          bookedSlots.add(slot);
          
        }
      }
    }

    return bookedSlots;
  }

  Future<String> createBooking(BookingModel booking) async {
    LoggerService.info(
      'Creating remote booking request for coach: ${booking.coachUid}',
      tag: 'BookingRequestRemoteDataSource',
    );

    final docRef = FirebaseFirestore.instance
        .collection(AppConstants.bookingsCollection)
        .doc();
    final bookingId = docRef.id;

    final fullBooking = BookingModel(
      id: bookingId,
      coachUid: booking.coachUid,
      coachName: booking.coachName,
      coachPhotoUrl: booking.coachPhotoUrl,
      traineeUid: booking.traineeUid,
      traineeName: booking.traineeName,
      traineePhotoUrl: booking.traineePhotoUrl,
      sport: booking.sport,
      date: booking.date,
      startTime: booking.startTime,
      endTime: booking.endTime,
      price: booking.price,
      currency: booking.currency,
      notes: booking.notes,
      status: 'pending',
    );

    await firestoreService.setData(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
      data: fullBooking.toMap(),
    );

    return bookingId;
  }
}
