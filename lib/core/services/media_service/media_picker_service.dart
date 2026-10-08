import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../logger_service/logger_service.dart';

class MediaPickerService {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from camera or gallery with optimal dimensions and compression.
  Future<File?> pickImage({
    required ImageSource source,
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      LoggerService.info('Picking image from: $source', tag: 'MediaPickerService');
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to pick image: $error',
        tag: 'MediaPickerService',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Picks a PDF document from device storage.
  Future<File?> pickPdfDocument() async {
    try {
      LoggerService.info('Picking PDF document', tag: 'MediaPickerService');
      final PlatformFile? result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );

      if (result != null && result.path != null) {
        return File(result.path!);
      }
      return null;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to pick PDF document: $error',
        tag: 'MediaPickerService',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
