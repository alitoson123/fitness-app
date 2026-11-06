import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../data_source/booking_details_remote_data_source.dart';

class BookingDetailsRepo {
  final BookingDetailsRemoteDataSource remoteDataSource;

  BookingDetailsRepo({required this.remoteDataSource});

  Stream<BookingModel> streamBooking(String bookingId) {
    return remoteDataSource.streamBooking(bookingId);
  }

  Future<Either<Failure, BookingModel>> getBooking(String bookingId) async {
    try {
      final booking = await remoteDataSource.getBooking(bookingId);
      if (booking == null) {
        return Left(ServerFailure(errorMessage: 'Booking not found'));
      }
      return Right(booking);
    } catch (e, st) {
      LoggerService.error('Error fetching booking', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateBookingStatus({
    required String bookingId,
    required String status,
    String? rejectionReason,
  }) async {
    try {
      await remoteDataSource.updateBookingStatus(
        bookingId: bookingId,
        status: status,
        rejectionReason: rejectionReason,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Error updating status', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String rescheduledBy,
  }) async {
    try {
      await remoteDataSource.requestReschedule(
        booking: booking,
        proposedDate: proposedDate,
        proposedStartTime: proposedStartTime,
        proposedEndTime: proposedEndTime,
        reason: reason,
        rescheduledBy: rescheduledBy,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Reschedule error', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> acceptReschedule({
    required BookingModel booking,
  }) async {
    try {
      await remoteDataSource.acceptReschedule(booking: booking);
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Accept reschedule error', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> declineReschedule({
    required String bookingId,
    String? declineReason,
  }) async {
    try {
      await remoteDataSource.declineReschedule(
        bookingId: bookingId,
        declineReason: declineReason,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Decline reschedule error', error: e, stackTrace: st);
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
    required String rescheduledBy,
  }) async {
    try {
      await remoteDataSource.requestMonthlySessionReschedule(
        bookingId: bookingId,
        sessionId: sessionId,
        proposedDate: proposedDate,
        proposedStartTime: proposedStartTime,
        proposedEndTime: proposedEndTime,
        reason: reason,
        rescheduledBy: rescheduledBy,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Session reschedule error', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> acceptMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
  }) async {
    try {
      await remoteDataSource.acceptMonthlySessionReschedule(
        bookingId: bookingId,
        sessionId: sessionId,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Accept session error', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> declineMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    String? declineReason,
  }) async {
    try {
      await remoteDataSource.declineMonthlySessionReschedule(
        bookingId: bookingId,
        sessionId: sessionId,
        declineReason: declineReason,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Decline session error', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> markSessionCompleted({
    required String bookingId,
    required String sessionId,
  }) async {
    try {
      await remoteDataSource.markSessionCompleted(
        bookingId: bookingId,
        sessionId: sessionId,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Complete session error', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}

