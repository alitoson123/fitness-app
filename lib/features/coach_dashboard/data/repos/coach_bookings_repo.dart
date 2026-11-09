import 'package:dartz/dartz.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../notifications/data/helpers/notification_safe_dispatcher.dart';
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        if (status == 'confirmed') {
          await d.dispatchBookingApproved(
            booking: booking,
            coachName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
          );
        } else if (status == 'rejected') {
          await d.dispatchBookingRejected(
            booking: booking,
            coachName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
            reason: rejectionReason ?? 'Unavailable',
          );
        }
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        await d.dispatchSingleRescheduleProposed(
          booking: booking,
          senderUid: booking.coachUid,
          senderName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
          recipientUid: booking.traineeUid,
          recipientRole: AppConstants.roleTrainee,
          proposedDate: proposedDate,
          proposedTime: proposedStartTime,
          reason: reason,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        await d.dispatchSingleRescheduleAccepted(
          booking: booking,
          senderUid: booking.coachUid,
          senderName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
          recipientUid: booking.traineeUid,
          recipientRole: AppConstants.roleTrainee,
          date: booking.proposedDate ?? booking.date,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        await d.dispatchSingleRescheduleDeclined(
          booking: booking,
          senderUid: booking.coachUid,
          senderName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
          recipientUid: booking.traineeUid,
          recipientRole: AppConstants.roleTrainee,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        final session = booking.sessions.firstWhere(
          (s) => s.id == sessionId,
          orElse: () => booking.sessions.first,
        );
        await d.dispatchMonthlyRescheduleProposed(
          booking: booking,
          sessionNumber: session.sessionNumber,
          sessionId: sessionId,
          senderUid: booking.coachUid,
          senderName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
          recipientUid: booking.traineeUid,
          recipientRole: AppConstants.roleTrainee,
          proposedDate: proposedDate,
          proposedTime: proposedStartTime,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        final session = booking.sessions.firstWhere(
          (s) => s.id == sessionId,
          orElse: () => booking.sessions.first,
        );
        await d.dispatchMonthlyRescheduleAccepted(
          booking: booking,
          sessionNumber: session.sessionNumber,
          sessionId: sessionId,
          senderUid: booking.coachUid,
          senderName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
          recipientUid: booking.traineeUid,
          recipientRole: AppConstants.roleTrainee,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        final session = booking.sessions.firstWhere(
          (s) => s.id == sessionId,
          orElse: () => booking.sessions.first,
        );
        await d.dispatchMonthlyRescheduleDeclined(
          booking: booking,
          sessionNumber: session.sessionNumber,
          sessionId: sessionId,
          senderUid: booking.coachUid,
          senderName: booking.coachName.isNotEmpty ? booking.coachName : 'Coach',
          recipientUid: booking.traineeUid,
          recipientRole: AppConstants.roleTrainee,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        final session = booking.sessions.firstWhere(
          (s) => s.id == sessionId,
          orElse: () => booking.sessions.first,
        );
        await d.dispatchMonthlySessionCompleted(
          booking: booking,
          sessionNumber: session.sessionNumber,
          sessionId: sessionId,
          completedCount: booking.completedSessionsCount + 1,
          totalCount: booking.sessions.length,
        );
      });
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
