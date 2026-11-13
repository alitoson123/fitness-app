import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/repos/booking_actions/booking_actions_repo.dart';
import '../data_source/coach_bookings_remote_data_source.dart';

/// Coach dashboard bookings. Reads come from the data source; every change
/// goes through the shared [BookingActionsRepo].
class CoachBookingsRepo {
  final CoachBookingsRemoteDataSource remoteDataSource;
  final BookingActionsRepo actions;

  CoachBookingsRepo({required this.remoteDataSource, required this.actions});

  Stream<List<BookingModel>> getCoachBookingsStream(String coachUid) {
    return remoteDataSource.getCoachBookingsStream(coachUid);
  }

  Future<Either<Failure, void>> approve(String bookingId) =>
      actions.approve(bookingId);

  Future<Either<Failure, void>> reject(String bookingId, {String? reason}) =>
      actions.reject(bookingId, reason: reason);

  Future<Either<Failure, void>> completeBooking(String bookingId) =>
      actions.completeBooking(bookingId);

  Future<Either<Failure, void>> requestReschedule({
    required String bookingId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) =>
      actions.proposeReschedule(
        bookingId: bookingId,
        date: proposedDate,
        startTime: proposedStartTime,
        endTime: proposedEndTime,
        reason: reason,
      );

  Future<Either<Failure, void>> acceptReschedule(String bookingId) =>
      actions.acceptReschedule(bookingId);

  Future<Either<Failure, void>> declineReschedule(
    String bookingId, {
    String? declineReason,
  }) =>
      actions.declineReschedule(bookingId, reason: declineReason);

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

  Future<Either<Failure, void>> markSessionCompleted({
    required String bookingId,
    required String sessionId,
  }) =>
      actions.completeSession(bookingId: bookingId, sessionId: sessionId);
}
