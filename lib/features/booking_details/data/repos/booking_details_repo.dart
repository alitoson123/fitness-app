import 'package:dartz/dartz.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../notifications/data/helpers/notification_safe_dispatcher.dart';
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        if (booking != null) {
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
          } else if (status == 'cancelled') {
            await d.dispatchBookingCancelled(
              booking: booking,
              traineeName: booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee',
            );
          }
        }
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final isCoach = rescheduledBy == AppConstants.roleCoach;
        await d.dispatchSingleRescheduleProposed(
          booking: booking,
          senderUid: isCoach ? booking.coachUid : booking.traineeUid,
          senderName: isCoach
              ? (booking.coachName.isNotEmpty ? booking.coachName : 'Coach')
              : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee'),
          recipientUid: isCoach ? booking.traineeUid : booking.coachUid,
          recipientRole:
              isCoach ? AppConstants.roleTrainee : AppConstants.roleCoach,
          proposedDate: proposedDate,
          proposedTime: proposedStartTime,
          reason: reason,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final isCoach = booking.rescheduledBy != AppConstants.roleCoach;
        await d.dispatchSingleRescheduleAccepted(
          booking: booking,
          senderUid: isCoach ? booking.coachUid : booking.traineeUid,
          senderName: isCoach
              ? (booking.coachName.isNotEmpty ? booking.coachName : 'Coach')
              : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee'),
          recipientUid: isCoach ? booking.traineeUid : booking.coachUid,
          recipientRole:
              isCoach ? AppConstants.roleTrainee : AppConstants.roleCoach,
          date: booking.proposedDate ?? booking.date,
        );
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        if (booking != null) {
          final isCoach = booking.rescheduledBy != AppConstants.roleCoach;
          await d.dispatchSingleRescheduleDeclined(
            booking: booking,
            senderUid: isCoach ? booking.coachUid : booking.traineeUid,
            senderName: isCoach
                ? (booking.coachName.isNotEmpty ? booking.coachName : 'Coach')
                : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee'),
            recipientUid: isCoach ? booking.traineeUid : booking.coachUid,
            recipientRole:
                isCoach ? AppConstants.roleTrainee : AppConstants.roleCoach,
          );
        }
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        if (booking != null) {
          final session = booking.sessions.firstWhere(
            (s) => s.id == sessionId,
            orElse: () => booking.sessions.first,
          );
          final isCoach = rescheduledBy == AppConstants.roleCoach;
          await d.dispatchMonthlyRescheduleProposed(
            booking: booking,
            sessionNumber: session.sessionNumber,
            sessionId: sessionId,
            senderUid: isCoach ? booking.coachUid : booking.traineeUid,
            senderName: isCoach
                ? (booking.coachName.isNotEmpty ? booking.coachName : 'Coach')
                : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee'),
            recipientUid: isCoach ? booking.traineeUid : booking.coachUid,
            recipientRole:
                isCoach ? AppConstants.roleTrainee : AppConstants.roleCoach,
            proposedDate: proposedDate,
            proposedTime: proposedStartTime,
          );
        }
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        if (booking != null) {
          final session = booking.sessions.firstWhere(
            (s) => s.id == sessionId,
            orElse: () => booking.sessions.first,
          );
          final isCoach = session.rescheduledBy != AppConstants.roleCoach;
          await d.dispatchMonthlyRescheduleAccepted(
            booking: booking,
            sessionNumber: session.sessionNumber,
            sessionId: sessionId,
            senderUid: isCoach ? booking.coachUid : booking.traineeUid,
            senderName: isCoach
                ? (booking.coachName.isNotEmpty ? booking.coachName : 'Coach')
                : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee'),
            recipientUid: isCoach ? booking.traineeUid : booking.coachUid,
            recipientRole:
                isCoach ? AppConstants.roleTrainee : AppConstants.roleCoach,
          );
        }
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        if (booking != null) {
          final session = booking.sessions.firstWhere(
            (s) => s.id == sessionId,
            orElse: () => booking.sessions.first,
          );
          final isCoach = session.rescheduledBy != AppConstants.roleCoach;
          await d.dispatchMonthlyRescheduleDeclined(
            booking: booking,
            sessionNumber: session.sessionNumber,
            sessionId: sessionId,
            senderUid: isCoach ? booking.coachUid : booking.traineeUid,
            senderName: isCoach
                ? (booking.coachName.isNotEmpty ? booking.coachName : 'Coach')
                : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee'),
            recipientUid: isCoach ? booking.traineeUid : booking.coachUid,
            recipientRole:
                isCoach ? AppConstants.roleTrainee : AppConstants.roleCoach,
          );
        }
      });
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
      NotificationSafeDispatcher.dispatch((d) async {
        final booking = await remoteDataSource.getBooking(bookingId);
        if (booking != null) {
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
        }
      });
      return const Right(null);
    } catch (e, st) {
      LoggerService.error('Complete session error', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}

