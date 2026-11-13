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

  /// Reads a document and writes an update based on it atomically, so two
  /// people editing the same document can't overwrite each other's change.
  /// [buildUpdate] receives the current data (null when the doc is missing)
  /// and returns the fields to update; it may throw to abort. Returns the
  /// data as it was before the update.
  Future<Map<String, dynamic>?> transactUpdate({
    required String collection,
    required String docId,
    required Map<String, dynamic> Function(Map<String, dynamic>? current)
        buildUpdate,
  }) async {
    LoggerService.debug(
      'Transactional update of $collection/$docId',
      tag: 'FirestoreService',
    );
    final ref = _firestore.collection(collection).doc(docId);
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = snap.data();
      final update = buildUpdate(current);
      tx.update(ref, {...update, 'updatedAt': FieldValue.serverTimestamp()});
      return current;
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
