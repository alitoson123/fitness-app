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
    LoggerService.info('Listening to bookings for trainee: $traineeUid', tag: 'TraineeBookingsRepo');
    return firestoreService
        .streamCollection(
          collection: AppConstants.bookingsCollection,
          queryBuilder: (q) => q.where('traineeUid', isEqualTo: traineeUid),
        )
        .map((snapshot) {
          final bookings = snapshot.docs
              .map((d) => BookingModel.fromJson(d.data(), id: d.id))
              .toList();
          bookings.sort((a, b) {
            final dateA = a.createdAt ?? DateTime.tryParse(a.date) ?? DateTime(1970);
            final dateB = b.createdAt ?? DateTime.tryParse(b.date) ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });
          return bookings;
        });
  }

  Future<Either<Failure, void>> acceptReschedule({required BookingModel booking}) async {
    try {
      if (booking.proposedDate == null || booking.proposedStartTime == null) {
        return Left(ServerFailure(errorMessage: 'Invalid proposed reschedule'));
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
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Failed to accept reschedule: $e', tag: 'TraineeBookingsRepo', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> approveReschedule({required BookingModel booking}) =>
      acceptReschedule(booking: booking);

  Future<Either<Failure, void>> declineReschedule({
    required String bookingId,
    String? declineReason,
  }) async {
    try {
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
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Failed to decline reschedule: $e', tag: 'TraineeBookingsRepo', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> rejectReschedule({required String bookingId, String? declineReason}) =>
      declineReschedule(bookingId: bookingId, declineReason: declineReason);

  Future<Either<Failure, void>> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) async {
    try {
      if (booking.status == 'completed' || booking.status == 'cancelled') {
        return Left(ServerFailure(
            errorMessage: 'Cannot reschedule a completed or cancelled booking'));
      }
      final data = <String, dynamic>{
        'status': 'reschedule_pending',
        'proposedDate': proposedDate,
        'proposedStartTime': proposedStartTime,
        'proposedEndTime': proposedEndTime,
        'rescheduleReason': reason.trim(),
        'rescheduledBy': AppConstants.roleTrainee,
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
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Failed to request reschedule: $e',
          tag: 'TraineeBookingsRepo', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> _updateMonthlyBooking(
    String bookingId,
    BookingModel Function(BookingModel current) transform,
  ) async {
    try {
      final doc = await firestoreService.getDoc(
        collection: AppConstants.bookingsCollection,
        docId: bookingId,
      );
      if (!doc.exists || doc.data() == null) {
        return Left(ServerFailure(errorMessage: 'Booking not found'));
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
      return const Right(null);
    } catch (e, st) {
      LoggerService.error(
        'Failed to update monthly booking session: $e',
        tag: 'TraineeBookingsRepo',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> requestMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) =>
      _updateMonthlyBooking(
        bookingId,
        (booking) => booking.proposeMonthlySessionReschedule(
          sessionId: sessionId,
          proposedDate: proposedDate,
          proposedStartTime: proposedStartTime,
          proposedEndTime: proposedEndTime,
          reason: reason,
          rescheduledBy: AppConstants.roleTrainee,
        ),
      );

  Future<Either<Failure, void>> acceptMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    String? preferredRestoredStatus,
  }) =>
      _updateMonthlyBooking(
        bookingId,
        (booking) => booking.acceptMonthlySessionReschedule(
          sessionId: sessionId,
          restoredStatus: preferredRestoredStatus,
        ),
      );

  Future<Either<Failure, void>> declineMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    String? declineReason,
    String? preferredRestoredStatus,
  }) =>
      _updateMonthlyBooking(
        bookingId,
        (booking) => booking.declineMonthlySessionReschedule(
          sessionId: sessionId,
          restoredStatus: preferredRestoredStatus,
        ),
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
