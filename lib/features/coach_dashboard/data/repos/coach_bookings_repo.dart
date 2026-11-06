import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../data_source/coach_bookings_remote_data_source.dart';

class CoachBookingsRepo {
  final CoachBookingsRemoteDataSource remoteDataSource;

  CoachBookingsRepo({required this.remoteDataSource});

  Stream<List<BookingModel>> getCoachBookingsStream(String coachUid) {
    return remoteDataSource.getCoachBookingsStream(coachUid);
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
      LoggerService.error(
        'Failed to update booking status: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: st,
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
      await remoteDataSource.requestReschedule(
        bookingId: bookingId,
        proposedDate: proposedDate,
        proposedStartTime: proposedStartTime,
        proposedEndTime: proposedEndTime,
        reason: reason,
        originalDate: originalDate,
        originalStartTime: originalStartTime,
        originalEndTime: originalEndTime,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error(
        'Failed to request reschedule: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: st,
      );
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
      LoggerService.error(
        'Failed to accept reschedule: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: st,
      );
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
      LoggerService.error(
        'Failed to decline reschedule: $e',
        tag: 'CoachBookingsRepo',
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
  }) async {
    try {
      await remoteDataSource.requestMonthlySessionReschedule(
        bookingId: bookingId,
        sessionId: sessionId,
        proposedDate: proposedDate,
        proposedStartTime: proposedStartTime,
        proposedEndTime: proposedEndTime,
        reason: reason,
      );
      return const Right(null);
    } catch (e, st) {
      LoggerService.error(
        'Failed to request monthly session reschedule: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: st,
      );
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
      LoggerService.error(
        'Failed to accept monthly session reschedule: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: st,
      );
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
      LoggerService.error(
        'Failed to decline monthly session reschedule: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: st,
      );
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
      LoggerService.error(
        'Failed to mark session completed: $e',
        tag: 'CoachBookingsRepo',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
