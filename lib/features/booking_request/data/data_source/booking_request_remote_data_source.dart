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

    final bookedSlots = <String>{};

    final singleSnapshot = await firestoreService.getCollection(
      collection: AppConstants.bookingsCollection,
      queryBuilder: (query) => query
          .where('coachUid', isEqualTo: coachUid)
          .where('date', isEqualTo: date),
    );

    for (final doc in singleSnapshot.docs) {
      final data = doc.data();
      final status = data['status'] as String? ?? '';
      if (status != 'rejected' && status != 'cancelled') {
        if (status != 'reschedule_pending') {
          final slot = data['startTime'] as String?;
          if (slot != null && slot.isNotEmpty) bookedSlots.add(slot);
        }
      }
    }

    final proposedSnapshot = await firestoreService.getCollection(
      collection: AppConstants.bookingsCollection,
      queryBuilder: (query) => query
          .where('coachUid', isEqualTo: coachUid)
          .where('proposedDate', isEqualTo: date),
    );

    for (final doc in proposedSnapshot.docs) {
      final data = doc.data();
      final status = data['status'] as String? ?? '';
      if (status == 'reschedule_pending') {
        final slot = data['proposedStartTime'] as String?;
        if (slot != null && slot.isNotEmpty) bookedSlots.add(slot);
      }
    }

    final monthlySnapshot = await firestoreService.getCollection(
      collection: AppConstants.bookingsCollection,
      queryBuilder: (query) => query
          .where('coachUid', isEqualTo: coachUid)
          .where('bookingType', isEqualTo: 'monthly'),
    );

    for (final doc in monthlySnapshot.docs) {
      final data = doc.data();
      final status = data['status'] as String? ?? '';
      if (status != 'rejected' && status != 'cancelled') {
        final sessions = data['sessions'];
        if (sessions is List) {
          for (final s in sessions) {
            if (s is Map && s['date'] == date) {
              final slot = s['startTime'] as String?;
              if (slot != null && slot.isNotEmpty) bookedSlots.add(slot);
            }
          }
        }
      }
    }

    return bookedSlots.toList();
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
