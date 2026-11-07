import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
    String? rejectionReason,
  }) async {
    final data = <String, dynamic>{
      'status': status,
      if (rejectionReason != null && rejectionReason.trim().isNotEmpty)
        'rejectionReason': rejectionReason.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await firestoreService.updateData(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
      data: data,
    );
  }

  Future<void> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String rescheduledBy,
  }) async {
    if (booking.status == 'completed' || booking.status == 'cancelled') {
      throw Exception('Cannot reschedule a completed or cancelled booking');
    }
    final data = <String, dynamic>{
      'status': 'reschedule_pending',
      'proposedDate': proposedDate,
      'proposedStartTime': proposedStartTime,
      'proposedEndTime': proposedEndTime,
      'rescheduleReason': reason.trim(),
      'rescheduledBy': rescheduledBy,
      'rescheduledAt': FieldValue.serverTimestamp(),
      'previousDate': booking.date,
      'previousStartTime': booking.startTime,
      'previousEndTime': booking.endTime,
      if (!booking.isMonthly) 'sessions': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await firestoreService.updateData(
      collection: AppConstants.bookingsCollection,
      docId: booking.id,
      data: data,
    );
  }

  Map<String, dynamic> _clearedProposalData() => {
        'proposedDate': null,
        'proposedStartTime': null,
        'proposedEndTime': null,
        'rescheduleReason': null,
        'rescheduledBy': null,
        'rescheduledAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  Future<void> acceptReschedule({required BookingModel booking}) async {
    if (booking.proposedDate == null || booking.proposedStartTime == null) {
      throw Exception('Invalid proposed reschedule');
    }
    final data = <String, dynamic>{
      'status': 'confirmed',
      'date': booking.proposedDate,
      'startTime': booking.proposedStartTime,
      'endTime': booking.proposedEndTime ?? booking.endTime,
      'previousDate': booking.date,
      'previousStartTime': booking.startTime,
      'previousEndTime': booking.endTime,
      if (!booking.isMonthly) 'sessions': FieldValue.delete(),
      ..._clearedProposalData(),
    };
    await firestoreService.updateData(
      collection: AppConstants.bookingsCollection,
      docId: booking.id,
      data: data,
    );
  }

  Future<void> declineReschedule({
    required String bookingId,
    String? declineReason,
  }) async {
    final reason = (declineReason != null && declineReason.trim().isNotEmpty)
        ? declineReason.trim()
        : null;
    final data = <String, dynamic>{
      'status': 'confirmed',
      'previousDate': null,
      'previousStartTime': null,
      'previousEndTime': null,
      'rescheduleDeclineReason': ?reason,
      ..._clearedProposalData(),
    };
    await firestoreService.updateData(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
      data: data,
    );
  }

  Future<void> _updateMonthlyBooking(
    String bookingId,
    BookingModel Function(BookingModel current) transform,
  ) async {
    final doc = await firestoreService.getDoc(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
    );
    if (!doc.exists || doc.data() == null) {
      throw Exception('Booking not found');
    }
    final current = BookingModel.fromJson(doc.data()!, id: doc.id);
    final updated = transform(current);

    await firestoreService.updateData(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
      data: {
        'status': updated.status,
        'sessions': updated.sessions.map((s) => s.toMap()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> requestMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String rescheduledBy,
  }) =>
      _updateMonthlyBooking(
        bookingId,
        (booking) => booking.proposeMonthlySessionReschedule(
          sessionId: sessionId,
          proposedDate: proposedDate,
          proposedStartTime: proposedStartTime,
          proposedEndTime: proposedEndTime,
          reason: reason,
          rescheduledBy: rescheduledBy,
        ),
      );

  Future<void> acceptMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
  }) =>
      _updateMonthlyBooking(
        bookingId,
        (booking) => booking.acceptMonthlySessionReschedule(
          sessionId: sessionId,
          restoredStatus: 'confirmed',
        ),
      );

  Future<void> declineMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    String? declineReason,
  }) =>
      _updateMonthlyBooking(
        bookingId,
        (booking) => booking.declineMonthlySessionReschedule(
          sessionId: sessionId,
          restoredStatus: 'confirmed',
        ),
      );

  Future<void> markSessionCompleted({
    required String bookingId,
    required String sessionId,
  }) =>
      _updateMonthlyBooking(
        bookingId,
        (booking) => booking.completeMonthlySession(sessionId: sessionId),
      );
}

