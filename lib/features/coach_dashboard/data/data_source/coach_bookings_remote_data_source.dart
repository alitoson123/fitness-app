import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';

class CoachBookingsRemoteDataSource {
  final FirestoreService firestoreService;

  CoachBookingsRemoteDataSource({required this.firestoreService});

  Stream<List<BookingModel>> getCoachBookingsStream(String coachUid) {
    LoggerService.info(
      'Listening to bookings for coach: $coachUid',
      tag: 'CoachBookingsRemoteDataSource',
    );
    return firestoreService
        .streamCollection(
          collection: AppConstants.bookingsCollection,
          queryBuilder: (q) => q.where('coachUid', isEqualTo: coachUid),
        )
        .map((snapshot) {
          final bookings = snapshot.docs
              .map((d) => BookingModel.fromJson(d.data(), id: d.id))
              .toList();
          bookings.sort((a, b) {
            final dateA =
                a.createdAt ?? DateTime.tryParse(a.date) ?? DateTime(1970);
            final dateB =
                b.createdAt ?? DateTime.tryParse(b.date) ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });
          return bookings;
        });
  }

  // Booking changes go through BookingActionsRepo (shared by every screen).
}
