import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/notification_service/fcm_token_manager.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: subtype_of_sealed_class
class _FakeDoc implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final bool exists;
  final Map<String, dynamic>? _data;
  _FakeDoc(this.exists, this._data);

  @override
  Map<String, dynamic>? data() => _data;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTokenFirestore implements FirestoreService {
  final Map<String, Map<String, dynamic>> docs = {};
  Map<String, dynamic>? lastSetData;
  Map<String, dynamic>? lastUpdateData;
  String? lastDeletedDoc;

  @override
  Future<void> setData({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    lastSetData = data;
    docs['$collection/$docId'] = {...?docs['$collection/$docId'], ...data};
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({
    required String collection,
    required String docId,
  }) async {
    final key = '$collection/$docId';
    return _FakeDoc(docs.containsKey(key), docs[key]);
  }

  @override
  Future<void> updateData({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    lastUpdateData = data;
  }

  @override
  Future<void> deleteDoc({
    required String collection,
    required String docId,
  }) async {
    lastDeletedDoc = '$collection/$docId';
    docs.remove(lastDeletedDoc);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('FcmTokenManager Tests (Milestone 11.2)', () {
    late FakeTokenFirestore firestore;
    late StreamController<String> refreshController;
    late FcmTokenManager manager;

    setUp(() {
      firestore = FakeTokenFirestore();
      refreshController = StreamController<String>.broadcast();
      manager = FcmTokenManager(
        firestoreService: firestore,
        tokenProvider: () async => 'fcm_tok_abc:123',
        tokenRefreshStream: refreshController.stream,
        platformProvider: () => 'android',
      );
    });

    tearDown(() => refreshController.close());

    test(
      'syncToken persists multi-device payload with language, role & enabled flag',
      () async {
        await manager.syncToken(
          uid: 'u_1',
          languageCode: 'ar',
          notificationsEnabled: true,
          role: 'coach',
        );

        final saved = firestore.lastSetData!;
        expect(saved['uid'], 'u_1');
        expect(saved['languageCode'], 'ar');
        expect(saved['notificationsEnabled'], isTrue);
        expect(saved['role'], 'coach');
        expect(saved['tokens'], isA<FieldValue>());
        final devices = saved['devices'] as Map<String, dynamic>;
        final expectedHash = FcmTokenManager.hashToken('fcm_tok_abc:123');
        expect(devices.containsKey(expectedHash), isTrue);
        expect(devices[expectedHash]['platform'], 'android');
      },
    );

    test(
      'detachToken removes only current device token & cancels refresh listener',
      () async {
        await manager.syncToken(
          uid: 'u_1',
          languageCode: 'en',
          notificationsEnabled: true,
        );

        await manager.detachToken('u_1');

        expect(firestore.lastUpdateData, isNotNull);
        expect(firestore.lastUpdateData!['tokens'], isA<FieldValue>());
        final hashKey =
            'devices.${FcmTokenManager.hashToken('fcm_tok_abc:123')}';
        expect(firestore.lastUpdateData![hashKey], isA<FieldValue>());

        firestore.lastSetData = null;
        refreshController.add('new_tok_after_signout');
        await Future<void>.delayed(Duration.zero);
        expect(firestore.lastSetData, isNull);
      },
    );

    test('deleteTokenDoc deletes fcm_tokens/{uid} completely', () async {
      await manager.syncToken(
        uid: 'u_2',
        languageCode: 'en',
        notificationsEnabled: true,
      );
      await manager.deleteTokenDoc('u_2');

      expect(
        firestore.lastDeletedDoc,
        '${AppConstants.fcmTokensCollection}/u_2',
      );
    });
  });
}
