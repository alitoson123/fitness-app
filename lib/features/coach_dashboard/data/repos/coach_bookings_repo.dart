import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';

class CoachBookingsRepo {
  final FirestoreService firestoreService;

  CoachBookingsRepo({required this.firestoreService});

  Stream<List<BookingModel>> getCoachBookingsStream(String coachUid) {
    LoggerService.info(
      'Listening to bookings for coach: $coachUid',
      tag: 'CoachBookingsRepo',
    );

    return firestoreService
        .streamCollection(
          collection: AppConstants.bookingsCollection,
          queryBuilder: (query) => query.where('coachUid', isEqualTo: coachUid),
        )
        .map((snapshot) {
          final bookings = snapshot.docs.map((doc) {
            return BookingModel.fromJson(doc.data(), id: doc.id);
          }).toList();

          bookings.sort((a, b) {
            final dateA = a.createdAt ?? DateTime.tryParse(a.date) ?? DateTime(1970);
            final dateB = b.createdAt ?? DateTime.tryParse(b.date) ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });

          return bookings;
        });
  }

  Future<Either<Failure, void>> updateBookingStatus({
    required String bookingId,
    required String status,
    String? rejectionReason,
  }) async {
    try {
      LoggerService.info(
        'Updating booking $bookingId status to $status',
        tag: 'CoachBookingsRepo',
      );

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

      return const Right(null);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to update booking status: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> requestReschedule({
    required String bookingId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String originalDate,
    required String originalStartTime,
    required String originalEndTime,
  }) async {
    try {
      LoggerService.info(
        'Requesting reschedule for booking $bookingId to $proposedDate $proposedStartTime',
        tag: 'CoachBookingsRepo',
      );

      final data = <String, dynamic>{
        'status': 'reschedule_pending',
        'proposedDate': proposedDate,
        'proposedStartTime': proposedStartTime,
        'proposedEndTime': proposedEndTime,
        'rescheduleReason': reason.trim(),
        'rescheduledBy': 'coach',
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

      return const Right(null);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to request reschedule: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
