import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';

class TraineeBookingsRepo {
  final FirestoreService firestoreService;

  TraineeBookingsRepo({required this.firestoreService});

  Stream<List<BookingModel>> getTraineeBookingsStream(String traineeUid) {
    LoggerService.info(
      'Listening to bookings for trainee: $traineeUid',
      tag: 'TraineeBookingsRepo',
    );

    return firestoreService
        .streamCollection(
          collection: AppConstants.bookingsCollection,
          queryBuilder: (q) => q.where('traineeUid', isEqualTo: traineeUid),
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

  Future<Either<Failure, void>> acceptReschedule({
    required BookingModel booking,
  }) async {
    try {
      if (booking.proposedDate == null || booking.proposedStartTime == null) {
        return Left(ServerFailure(errorMessage: 'Invalid proposed reschedule'));
      }

      LoggerService.info(
        'Accepting reschedule for booking ${booking.id}',
        tag: 'TraineeBookingsRepo',
      );

      final data = <String, dynamic>{
        'status': 'confirmed',
        'date': booking.proposedDate,
        'startTime': booking.proposedStartTime,
        'endTime': booking.proposedEndTime ?? booking.endTime,
        'previousDate': booking.date,
        'previousStartTime': booking.startTime,
        'previousEndTime': booking.endTime,
        ..._clearedProposalData(),
      };

      await firestoreService.updateData(
        collection: AppConstants.bookingsCollection,
        docId: booking.id,
        data: data,
      );

      return const Right(null);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to accept reschedule: $e',
        tag: 'TraineeBookingsRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> approveReschedule({
    required BookingModel booking,
  }) =>
      acceptReschedule(booking: booking);

  Future<Either<Failure, void>> declineReschedule({
    required String bookingId,
    String? declineReason,
  }) async {
    try {
      final reason = (declineReason != null && declineReason.trim().isNotEmpty)
          ? declineReason.trim()
          : 'Reschedule declined by trainee';

      LoggerService.info(
        'Declining reschedule for booking $bookingId ($reason)',
        tag: 'TraineeBookingsRepo',
      );

      final data = <String, dynamic>{
        'status': 'cancelled',
        'cancellationReason': reason,
        ..._clearedProposalData(),
      };

      await firestoreService.updateData(
        collection: AppConstants.bookingsCollection,
        docId: bookingId,
        data: data,
      );

      return const Right(null);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to decline reschedule: $e',
        tag: 'TraineeBookingsRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> rejectReschedule({
    required String bookingId,
    String? declineReason,
  }) =>
      declineReschedule(
        bookingId: bookingId,
        declineReason: declineReason,
      );

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
