import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../generated/l10n.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => DeleteAccountDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      backgroundColor: cardBg,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                color: AppColors.error,
                size: 28.r,
              ),
            ),
            SizedBox(height: AppSpacing.s4),
            Text(
              S.of(context).deleteAccountConfirmationTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.s2),
            Text(
              S.of(context).deleteAccountConfirmationMessage,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.4,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.s6),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: S.of(context).cancel,
                    variant: AppButtonVariant.outlined,
                    size: AppButtonSize.sm,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: AppButton(
                    label: S.of(context).deleteAccountConfirm,
                    variant: AppButtonVariant.destructive,
                    size: AppButtonSize.sm,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
