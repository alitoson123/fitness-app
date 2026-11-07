import 'package:cloud_firestore/cloud_firestore.dart';
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
    required String bookingId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String originalDate,
    required String originalStartTime,
    required String originalEndTime,
  }) async {
    final data = <String, dynamic>{
      'status': 'reschedule_pending',
      'proposedDate': proposedDate,
      'proposedStartTime': proposedStartTime,
      'proposedEndTime': proposedEndTime,
      'rescheduleReason': reason.trim(),
      'rescheduledBy': AppConstants.roleCoach,
      'rescheduledAt': FieldValue.serverTimestamp(),
      'previousDate': originalDate,
      'previousStartTime': originalStartTime,
      'previousEndTime': originalEndTime,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await firestoreService.updateData(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
      data: data,
    );
  }

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

  Future<BookingModel> _getBooking(String bookingId) async {
    final doc = await firestoreService.getDoc(
      collection: AppConstants.bookingsCollection,
      docId: bookingId,
    );
    if (!doc.exists || doc.data() == null) {
      throw Exception('Booking not found');
    }
    return BookingModel.fromJson(doc.data()!, id: doc.id);
  }

  Future<void> _updateBookingSessions(
    String bookingId,
    BookingModel updated,
  ) async {
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
  }) async {
    final booking = await _getBooking(bookingId);
    final updated = booking.proposeMonthlySessionReschedule(
      sessionId: sessionId,
      proposedDate: proposedDate,
      proposedStartTime: proposedStartTime,
      proposedEndTime: proposedEndTime,
      reason: reason,
      rescheduledBy: AppConstants.roleCoach,
    );
    await _updateBookingSessions(bookingId, updated);
  }

  Future<void> acceptMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
  }) async {
    final booking = await _getBooking(bookingId);
    final updated = booking.acceptMonthlySessionReschedule(
      sessionId: sessionId,
      restoredStatus: 'confirmed',
    );
    await _updateBookingSessions(bookingId, updated);
  }

  Future<void> declineMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    String? declineReason,
  }) async {
    final booking = await _getBooking(bookingId);
    final updated = booking.declineMonthlySessionReschedule(
      sessionId: sessionId,
      restoredStatus: 'confirmed',
    );
    await _updateBookingSessions(bookingId, updated);
  }

  Future<void> markSessionCompleted({
    required String bookingId,
    required String sessionId,
  }) async {
    final booking = await _getBooking(bookingId);
    final updated = booking.completeMonthlySession(sessionId: sessionId);
    await _updateBookingSessions(bookingId, updated);
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
}
