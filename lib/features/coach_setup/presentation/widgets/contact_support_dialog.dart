import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';

class ContactSupportDialog extends StatelessWidget {
  const ContactSupportDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const ContactSupportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent_rounded,
                size: 30.r,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.s3),
            Text(
              s.supportModalTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.s2),
            Text(
              s.supportModalDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppSpacing.s4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
                borderRadius: AppRadius.mdAll,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline_rounded,
                      size: 18.r, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  SelectableText(
                    s.supportEmail,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.s4),
            AppButton(
              label: s.copyEmail,
              variant: AppButtonVariant.primary,
              fullWidth: true,
              icon: Icon(Icons.copy_rounded, size: 16.r),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: s.supportEmail));
                Message.showSuccess(context, s.emailCopied);
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: AppSpacing.s2),
            AppButton(
              label: s.back,
              variant: AppButtonVariant.text,
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
