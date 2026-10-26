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

  Future<Either<Failure, void>> approveReschedule({
    required BookingModel booking,
  }) async {
    try {
      if (booking.proposedDate == null || booking.proposedStartTime == null) {
        return Left(ServerFailure(errorMessage: 'Invalid proposed reschedule'));
      }

      LoggerService.info(
        'Approving reschedule for booking ${booking.id}',
        tag: 'TraineeBookingsRepo',
      );

      final data = <String, dynamic>{
        'status': 'confirmed',
        'date': booking.proposedDate,
        'startTime': booking.proposedStartTime,
        'endTime': booking.proposedEndTime ?? booking.endTime,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestoreService.updateData(
        collection: AppConstants.bookingsCollection,
        docId: booking.id,
        data: data,
      );

      return const Right(null);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to approve reschedule: $e',
        tag: 'TraineeBookingsRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> rejectReschedule({
    required String bookingId,
  }) async {
    try {
      LoggerService.info(
        'Rejecting reschedule for booking $bookingId',
        tag: 'TraineeBookingsRepo',
      );

      final data = <String, dynamic>{
        'status': 'cancelled',
        'cancellationReason': 'Reschedule declined by trainee',
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
        'Failed to reject reschedule: $e',
        tag: 'TraineeBookingsRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
