import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setData({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    LoggerService.debug('Setting data in $collection/$docId', tag: 'FirestoreService');
    await _firestore.collection(collection).doc(docId).set(
      {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: merge),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({
    required String collection,
    required String docId,
  }) async {
    LoggerService.debug('Fetching doc $collection/$docId', tag: 'FirestoreService');
    return await _firestore.collection(collection).doc(docId).get();
  }

  Future<void> updateData({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    LoggerService.debug('Updating doc $collection/$docId', tag: 'FirestoreService');
    await _firestore.collection(collection).doc(docId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDoc({
    required String collection,
    required String docId,
  }) async {
    LoggerService.debug('Deleting doc $collection/$docId', tag: 'FirestoreService');
    await _firestore.collection(collection).doc(docId).delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) async {
    LoggerService.debug('Fetching collection $collection', tag: 'FirestoreService');
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return await query.get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDoc({
    required String collection,
    required String docId,
  }) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collection,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }
}
