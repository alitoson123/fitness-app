import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';

class BookingDetailsRemoteDataSource {
  final FirestoreService firestoreService;

  BookingDetailsRemoteDataSource({required this.firestoreService});

  Stream<BookingModel> streamBooking(String bookingId) {
    LoggerService.info(
      'Streaming booking details for: $bookingId',
      tag: 'BookingDetailsRemoteDataSource',
    );
    return firestoreService
        .streamDoc(
          collection: AppConstants.bookingsCollection,
          docId: bookingId,
        )
        .where((doc) => doc.exists && doc.data() != null)
        .map((doc) => BookingModel.fromJson(doc.data()!, id: doc.id));
  }

  Future<BookingModel?> getBooking(String bookingId) async {
    final doc = await firestoreService.getDoc(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
    );
    if (!doc.exists || doc.data() == null) return null;
    return BookingModel.fromJson(doc.data()!, id: doc.id);
  }

  // Booking changes go through BookingActionsRepo (shared by every screen).
}
