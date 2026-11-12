import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constant/app_constants.dart';
import '../database_service/firestore_service.dart';

/// Builds and persists Firestore payloads for multi-device FCM tokens.
class FcmTokenStorageHelper {
  final FirestoreService firestoreService;

  FcmTokenStorageHelper({required this.firestoreService});

  Future<void> saveToken({
    required String uid,
    required String token,
    required String platform,
    required String languageCode,
    required bool notificationsEnabled,
    String? role,
  }) async {
    await firestoreService.setData(
      collection: AppConstants.fcmTokensCollection,
      docId: uid,
      data: {
        'uid': uid,
        'tokens': FieldValue.arrayUnion([token]),
        'devices': {
          hashToken(token): {
            'platform': platform,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        },
        'languageCode': languageCode,
        'notificationsEnabled': notificationsEnabled,
        if (role != null && role.isNotEmpty) 'role': role,
      },
    );
  }

  Future<void> updatePreferences({
    required String uid,
    String? languageCode,
    bool? notificationsEnabled,
    String? role,
  }) async {
    await firestoreService.setData(
      collection: AppConstants.fcmTokensCollection,
      docId: uid,
      data: {
        'uid': uid,
        'languageCode': ?languageCode,
        'notificationsEnabled': ?notificationsEnabled,
        if (role != null && role.isNotEmpty) 'role': role,
      },
    );
  }

  Future<void> removeToken({required String uid, required String token}) async {
    final doc = await firestoreService.getDoc(
      collection: AppConstants.fcmTokensCollection,
      docId: uid,
    );
    if (!doc.exists) return;
    await firestoreService.updateData(
      collection: AppConstants.fcmTokensCollection,
      docId: uid,
      data: {
        'tokens': FieldValue.arrayRemove([token]),
        'devices.${hashToken(token)}': FieldValue.delete(),
      },
    );
  }

  Future<void> deleteDoc(String uid) {
    return firestoreService.deleteDoc(
      collection: AppConstants.fcmTokensCollection,
      docId: uid,
    );
  }

  /// Deterministic 16-hex-char hash avoiding invalid Firestore map key chars.
  static String hashToken(String token) {
    var h1 = 5381;
    var h2 = 2166136261;
    for (final unit in token.codeUnits) {
      h1 = (((h1 << 5) + h1) + unit) & 0xffffffff;
      h2 = (((h2 << 5) - h2) ^ unit) & 0xffffffff;
    }
    return '${h1.toRadixString(16).padLeft(8, '0')}'
        '${h2.toRadixString(16).padLeft(8, '0')}';
  }
}
