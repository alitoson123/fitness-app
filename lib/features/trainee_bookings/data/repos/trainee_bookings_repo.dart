import 'package:dartz/dartz.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/repos/booking_actions/booking_actions_repo.dart';

/// Trainee "My bookings" tab. Reads are local to this feature; every change
/// goes through the shared [BookingActionsRepo].
class TraineeBookingsRepo {
  final FirestoreService firestoreService;
  final BookingActionsRepo actions;

  TraineeBookingsRepo({required this.firestoreService, required this.actions});

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

  Future<Either<Failure, void>> acceptReschedule({required BookingModel booking}) =>
      actions.acceptReschedule(booking.id);

  Future<Either<Failure, void>> approveReschedule({required BookingModel booking}) =>
      acceptReschedule(booking: booking);

  Future<Either<Failure, void>> declineReschedule({
    required String bookingId,
    String? declineReason,
  }) =>
      actions.declineReschedule(bookingId, reason: declineReason);

  Future<Either<Failure, void>> rejectReschedule({required String bookingId, String? declineReason}) =>
      declineReschedule(bookingId: bookingId, declineReason: declineReason);

  Future<Either<Failure, void>> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) =>
      actions.proposeReschedule(
        bookingId: booking.id,
        date: proposedDate,
        startTime: proposedStartTime,
        endTime: proposedEndTime,
        reason: reason,
      );

  Future<Either<Failure, void>> requestMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) =>
      actions.proposeSessionReschedule(
        bookingId: bookingId,
        sessionId: sessionId,
        date: proposedDate,
        startTime: proposedStartTime,
        endTime: proposedEndTime,
        reason: reason,
      );

  Future<Either<Failure, void>> acceptMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
  }) =>
      actions.acceptSessionReschedule(bookingId: bookingId, sessionId: sessionId);

  Future<Either<Failure, void>> declineMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
  }) =>
      actions.declineSessionReschedule(bookingId: bookingId, sessionId: sessionId);

  Future<Either<Failure, void>> cancelBooking({
    required String bookingId,
    String? cancellationReason,
  }) =>
      actions.cancel(bookingId, reason: cancellationReason);
}
