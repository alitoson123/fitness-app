import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../data_source/notifications_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepository({required this.remoteDataSource});

  Stream<List<NotificationModel>> streamNotifications(String recipientUid) {
    return remoteDataSource.streamNotifications(recipientUid);
  }

  Stream<int> streamUnreadCount(String recipientUid) {
    return remoteDataSource.streamUnreadCount(recipientUid);
  }

  Future<Either<Failure, String>> sendNotification(
    NotificationModel notification,
  ) async {
    try {
      final id = await remoteDataSource.sendNotification(notification);
      return Right(id);
    } catch (e, st) {
      LoggerService.error(
        'Failed to send notification: $e',
        tag: 'NotificationsRepository',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, List<NotificationModel>>> getNotifications({
    required String recipientUid,
    int? limit,
    String? type,
  }) async {
    try {
      final items = await remoteDataSource.getNotifications(
        recipientUid: recipientUid,
        limit: limit,
        type: type,
      );
      return Right(items);
    } catch (e, st) {
      LoggerService.error(
        'Failed to fetch notifications: $e',
        tag: 'NotificationsRepository',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e, st) {
      LoggerService.error(
        'Failed to mark notification as read: $e',
        tag: 'NotificationsRepository',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> markAllAsRead(String recipientUid) async {
    try {
      await remoteDataSource.markAllAsRead(recipientUid);
      return const Right(null);
    } catch (e, st) {
      LoggerService.error(
        'Failed to mark all as read: $e',
        tag: 'NotificationsRepository',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteNotification(
    String notificationId,
  ) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e, st) {
      LoggerService.error(
        'Failed to delete notification: $e',
        tag: 'NotificationsRepository',
        error: e,
        stackTrace: st,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
