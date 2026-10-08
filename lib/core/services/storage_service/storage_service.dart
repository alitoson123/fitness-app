import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../logger_service/logger_service.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the public download URL.
  Future<String> uploadFile({
    required File file,
    required String storagePath,
    String? contentType,
  }) async {
    try {
      LoggerService.info('Uploading file to: $storagePath', tag: 'StorageService');
      final ref = _storage.ref().child(storagePath);
      final metadata = contentType != null
          ? SettableMetadata(contentType: contentType)
          : null;

      final uploadTask = ref.putFile(file, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      LoggerService.info('Upload successful: $downloadUrl', tag: 'StorageService');
      return downloadUrl;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to upload file to storage: $error',
        tag: 'StorageService',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Deletes a file from Firebase Storage given its download URL.
  Future<void> deleteFileByUrl(String fileUrl) async {
    try {
      LoggerService.info('Deleting file at: $fileUrl', tag: 'StorageService');
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (error) {
      LoggerService.warning(
        'Failed to delete file from storage: $error',
        tag: 'StorageService',
      );
    }
  }
}
