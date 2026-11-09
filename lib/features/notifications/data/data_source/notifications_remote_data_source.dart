import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/services/database_service/firestore_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../models/notification_model.dart';

class NotificationsRemoteDataSource {
  final FirestoreService firestoreService;

  NotificationsRemoteDataSource({required this.firestoreService});

  Future<String> sendNotification(NotificationModel notification) async {
    final isAdmin = notification.recipientRole == AppConstants.roleAdmin ||
        notification.recipientUid == AppConstants.roleAdmin;
    final targetCollection = isAdmin
        ? AppConstants.adminNotificationsCollection
        : AppConstants.notificationsCollection;

    final docRef = FirebaseFirestore.instance
        .collection(targetCollection)
        .doc(notification.id.isNotEmpty ? notification.id : null);
    final id = docRef.id;
    final item = notification.copyWith(id: id);

    LoggerService.info(
      'Sending notification: $id of type ${item.type} to ${item.recipientUid}'
      ' in $targetCollection',
      tag: 'NotificationsRemoteDataSource',
    );

    await firestoreService.setData(
      collection: targetCollection,
      docId: id,
      data: item.toMap(),
    );
    return id;
  }

  Stream<List<NotificationModel>> streamNotifications(String recipientUid) {
    LoggerService.info(
      'Streaming notifications for: $recipientUid',
      tag: 'NotificationsRemoteDataSource',
    );
    return firestoreService
        .streamCollection(
          collection: AppConstants.notificationsCollection,
          queryBuilder: (query) =>
              query.where('recipientUid', isEqualTo: recipientUid),
        )
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), id: doc.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  Future<List<NotificationModel>> getNotifications({
    required String recipientUid,
    int? limit,
    String? type,
  }) async {
    final snapshot = await firestoreService.getCollection(
      collection: AppConstants.notificationsCollection,
      queryBuilder: (query) {
        var q = query.where('recipientUid', isEqualTo: recipientUid);
        if (type != null && type.isNotEmpty) {
          q = q.where('type', isEqualTo: type);
        }
        if (limit != null && limit > 0) {
          q = q.limit(limit);
        }
        return q;
      },
    );

    final list = snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data(), id: doc.id))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> markAsRead(String notificationId) async {
    await firestoreService.updateData(
      collection: AppConstants.notificationsCollection,
      docId: notificationId,
      data: {'isRead': true},
    );
  }

  Future<void> markAllAsRead(String recipientUid) async {
    final snapshot = await firestoreService.getCollection(
      collection: AppConstants.notificationsCollection,
      queryBuilder: (query) => query
          .where('recipientUid', isEqualTo: recipientUid)
          .where('isRead', isEqualTo: false),
    );

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'isRead': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> deleteNotification(String notificationId) async {
    await firestoreService.deleteDoc(
      collection: AppConstants.notificationsCollection,
      docId: notificationId,
    );
  }

  Stream<int> streamUnreadCount(String recipientUid) {
    return firestoreService
        .streamCollection(
          collection: AppConstants.notificationsCollection,
          queryBuilder: (query) => query
              .where('recipientUid', isEqualTo: recipientUid)
              .where('isRead', isEqualTo: false),
        )
        .map((snapshot) => snapshot.docs.length);
  }
}
