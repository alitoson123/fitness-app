import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/repos/booking_actions/booking_actions_repo.dart';
import '../data_source/booking_details_remote_data_source.dart';

/// Booking Details screen (shared by coach and trainee). Reads come from the
/// data source; every change goes through [BookingActionsRepo], which works
/// out from the signed-in user whether they act as coach or trainee.
class BookingDetailsRepo {
  final BookingDetailsRemoteDataSource remoteDataSource;
  final BookingActionsRepo actions;

  BookingDetailsRepo({required this.remoteDataSource, required this.actions});

  Stream<BookingModel> streamBooking(String bookingId) {
    return remoteDataSource.streamBooking(bookingId);
  }

  Future<Either<Failure, BookingModel>> getBooking(String bookingId) async {
    try {
      final booking = await remoteDataSource.getBooking(bookingId);
      if (booking == null) {
        return Left(ServerFailure(errorMessage: S.current.bookingNotFoundMessage));
      }
      return Right(booking);
    } catch (e, st) {
      LoggerService.error('Error fetching booking', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: S.current.unexpectedErrorMessage));
    }
  }

  Future<Either<Failure, void>> approve(String bookingId) =>
      actions.approve(bookingId);

  Future<Either<Failure, void>> reject(String bookingId, {String? reason}) =>
      actions.reject(bookingId, reason: reason);

  Future<Either<Failure, void>> cancel(String bookingId, {String? reason}) =>
      actions.cancel(bookingId, reason: reason);

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
