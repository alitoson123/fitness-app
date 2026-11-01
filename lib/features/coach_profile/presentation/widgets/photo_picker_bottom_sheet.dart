import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/media_service/media_picker_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';

class PhotoPickerBottomSheet extends StatelessWidget {
  const PhotoPickerBottomSheet({super.key});

  static Future<File?> show(BuildContext context) {
    return showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const PhotoPickerBottomSheet(),
    );
  }

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final picker = getIt<MediaPickerService>();
    final file = await picker.pickImage(source: source);
    if (context.mounted && file != null) {
      Navigator.of(context).pop(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.surface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                s.changePhoto,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.s4),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: AppColors.primary),
                ),
                title: Text(s.takePhoto),
                onTap: () => _pick(context, ImageSource.camera),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: AppColors.secondary),
                ),
                title: Text(s.chooseFromGallery),
                onTap: () => _pick(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

