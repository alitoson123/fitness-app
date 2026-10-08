import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/media_service/media_picker_service.dart';
import '../../../../core/services/storage_service/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/image_source_bottom_sheet.dart';
import '../../../../generated/l10n.dart';

class AvatarUploadCircle extends StatefulWidget {
  final String? photoUrl;
  final ValueChanged<String?> onPhotoSelected;

  const AvatarUploadCircle({
    super.key,
    required this.photoUrl,
    required this.onPhotoSelected,
  });

  @override
  State<AvatarUploadCircle> createState() => _AvatarUploadCircleState();
}

class _AvatarUploadCircleState extends State<AvatarUploadCircle> {
  File? _localImageFile;
  bool _isUploading = false;

  bool get _hasPhoto =>
      _localImageFile != null ||
      (widget.photoUrl != null && widget.photoUrl!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _isUploading ? null : _handleAvatarTap,
            child: Stack(
              children: [
                Container(
                  width: 96.r,
                  height: 96.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : const Color(0xFFE0F2FE),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFBAE6FD),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(child: _buildAvatarContent(isDark)),
                ),
                if (_isUploading)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 28.r,
                          height: 28.r,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 16.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            _isUploading
                ? S.of(context).uploadingPhoto
                : S.of(context).tapToUploadPhoto,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent(bool isDark) {
    if (_localImageFile != null) {
      return Image.file(
        _localImageFile!,
        width: 96.r,
        height: 96.r,
        fit: BoxFit.cover,
      );
    }
    if (widget.photoUrl != null &&
        widget.photoUrl!.isNotEmpty &&
        widget.photoUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: widget.photoUrl!,
        width: 96.r,
        height: 96.r,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) => _buildPlaceholder(isDark),
      );
    }
    return _buildPlaceholder(isDark);
  }

  Widget _buildPlaceholder(bool isDark) {
    return Center(
      child: Icon(
        Icons.person_outline_rounded,
        size: 48.r,
        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF60A5FA),
      ),
    );
  }

  Future<void> _handleAvatarTap() async {
    final action = await ImageSourceBottomSheet.show(
      context,
      hasExistingPhoto: _hasPhoto,
    );
    if (action == null) return;

    if (action == ImagePickerAction.remove) {
      setState(() => _localImageFile = null);
      widget.onPhotoSelected(null);
      return;
    }

    final source = action == ImagePickerAction.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    final mediaService = getIt<MediaPickerService>();
    final pickedFile = await mediaService.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _localImageFile = pickedFile;
      _isUploading = true;
    });

    try {
      final authService = getIt<AuthService>();
      final storageService = getIt<StorageService>();
      final uid = authService.currentUser?.uid ??
          'guest_${DateTime.now().millisecondsSinceEpoch}';
      final storagePath =
          'avatars/${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final downloadUrl = await storageService.uploadFile(
        file: pickedFile,
        storagePath: storagePath,
        contentType: 'image/jpeg',
      );

      if (mounted) {
        widget.onPhotoSelected(downloadUrl);
        Message.showSuccess(context, S.of(context).photoUploadedSuccess);
      }
    } catch (e) {
      if (mounted) {
        Message.showError(context, S.of(context).photoUploadFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }
}
