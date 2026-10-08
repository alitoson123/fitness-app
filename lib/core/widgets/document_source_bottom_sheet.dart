import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'picker_option_tile.dart';

enum DocumentPickerAction { camera, gallery, pdf, remove }

class DocumentSourceBottomSheet extends StatelessWidget {
  final bool hasExistingFile;

  const DocumentSourceBottomSheet({
    super.key,
    this.hasExistingFile = false,
  });

  static Future<DocumentPickerAction?> show(
    BuildContext context, {
    bool hasExistingFile = false,
  }) {
    return showModalBottomSheet<DocumentPickerAction>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) =>
          DocumentSourceBottomSheet(hasExistingFile: hasExistingFile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                borderRadius: AppRadius.fullAll,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.s4),
          Text(
            S.of(context).chooseDocumentSource,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.s4),
          PickerOptionTile(
            icon: Icons.photo_camera_rounded,
            title: S.of(context).camera,
            color: primary,
            onTap: () => Navigator.of(context).pop(DocumentPickerAction.camera),
          ),
          SizedBox(height: AppSpacing.s2),
          PickerOptionTile(
            icon: Icons.photo_library_rounded,
            title: S.of(context).gallery,
            color: AppColors.secondary,
            onTap: () =>
                Navigator.of(context).pop(DocumentPickerAction.gallery),
          ),
          SizedBox(height: AppSpacing.s2),
          PickerOptionTile(
            icon: Icons.picture_as_pdf_rounded,
            title: S.of(context).pdfDocument,
            color: const Color(0xFFE53935),
            onTap: () => Navigator.of(context).pop(DocumentPickerAction.pdf),
          ),
          if (hasExistingFile) ...[
            SizedBox(height: AppSpacing.s2),
            PickerOptionTile(
              icon: Icons.delete_outline_rounded,
              title: S.of(context).removeDocument,
              color: AppColors.error,
              onTap: () =>
                  Navigator.of(context).pop(DocumentPickerAction.remove),
            ),
          ],
        ],
      ),
    );
  }
}
