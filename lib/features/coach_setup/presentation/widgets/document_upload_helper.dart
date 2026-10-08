import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/media_service/media_picker_service.dart';
import '../../../../core/services/storage_service/storage_service.dart';
import '../../../../core/widgets/document_source_bottom_sheet.dart';
import '../../../../generated/l10n.dart';

class DocumentUploadHelper {
  static Future<String?> pickAndUploadDocument({
    required BuildContext context,
    required String currentFileUrl,
    required String folder,
    required VoidCallback onRemove,
  }) async {
    final action = await DocumentSourceBottomSheet.show(
      context,
      hasExistingFile: currentFileUrl.isNotEmpty,
    );
    if (action == null) return null;

    if (action == DocumentPickerAction.remove) {
      await removeFile(currentFileUrl);
      onRemove();
      return null;
    }

    final mediaService = getIt<MediaPickerService>();
    final File? pickedFile;

    if (action == DocumentPickerAction.pdf) {
      pickedFile = await mediaService.pickPdfDocument();
    } else {
      final source = action == DocumentPickerAction.camera
          ? ImageSource.camera
          : ImageSource.gallery;
      pickedFile = await mediaService.pickImage(source: source);
    }

    if (pickedFile == null) return null;

    if (pickedFile.lengthSync() > 10 * 1024 * 1024) {
      if (context.mounted) {
        Message.showError(context, S.of(context).fileTooLarge);
      }
      return null;
    }

    try {
      final authService = getIt<AuthService>();
      final storageService = getIt<StorageService>();
      final uid = authService.currentUser?.uid ??
          'guest_${DateTime.now().millisecondsSinceEpoch}';

      final isPdf = pickedFile.path.toLowerCase().endsWith('.pdf');
      final ext = isPdf ? 'pdf' : 'jpg';
      final contentType = isPdf ? 'application/pdf' : 'image/jpeg';
      final path =
          'coach_documents/${uid}_${folder}_${DateTime.now().millisecondsSinceEpoch}.$ext';

      final downloadUrl = await storageService.uploadFile(
        file: pickedFile,
        storagePath: path,
        contentType: contentType,
      );

      if (currentFileUrl.isNotEmpty && currentFileUrl.startsWith('http')) {
        await storageService.deleteFileByUrl(currentFileUrl);
      }

      if (context.mounted) {
        Message.showSuccess(context, S.of(context).documentUploadedSuccess);
      }
      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        Message.showError(context, S.of(context).uploadFailed);
      }
      rethrow;
    }
  }

  static Future<void> removeFile(String fileUrl) async {
    if (fileUrl.isNotEmpty && fileUrl.startsWith('http')) {
      final storageService = getIt<StorageService>();
      await storageService.deleteFileByUrl(fileUrl);
    }
  }
}

