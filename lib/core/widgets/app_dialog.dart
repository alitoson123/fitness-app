import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

enum DialogType { success, error, warning }

class AppDialog extends StatelessWidget {
  final DialogType type;
  final String message;
  final String? title;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool isVerifyButton;
  final VoidCallback? onVerifyPressed;
  final String? verifyButtonText;

  const AppDialog({
    super.key,
    required this.type,
    required this.message,
    this.title,
    this.buttonText,
    this.onButtonPressed,
    this.isVerifyButton = false,
    this.onVerifyPressed,
    this.verifyButtonText,
  });

  _DialogConfig _getConfig(BuildContext context) {
    switch (type) {
      case DialogType.success:
        return _DialogConfig(
          icon: Icons.check_rounded,
          color: AppColors.success,
          iconBg: AppColors.successLight,
          defaultTitle: S.of(context).success,
        );
      case DialogType.error:
        return _DialogConfig(
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
          iconBg: AppColors.errorLight,
          defaultTitle: S.of(context).error,
        );
      case DialogType.warning:
        return _DialogConfig(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
          iconBg: AppColors.warningLight,
          defaultTitle: S.of(context).warning,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBg = isDark ? config.color.withValues(alpha: 0.18) : config.iconBg;
    final textColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(config.icon, color: config.color, size: 32.r),
            ),
            SizedBox(height: 16.h),
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
            ],
            Text(
              message.isNotEmpty ? message : config.defaultTitle,
              style: TextStyle(fontSize: 14.sp, color: textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onButtonPressed?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.color,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonText ?? S.of(context).ok,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                if (isVerifyButton) ...[
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onVerifyPressed?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: config.color,
                        side: BorderSide(color: config.color, width: 2.w),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
                      ),
                      child: Text(
                        verifyButtonText ?? S.of(context).resend,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogConfig {
  final IconData icon;
  final Color color;
  final Color iconBg;
  final String defaultTitle;
  const _DialogConfig({
    required this.icon,
    required this.color,
    required this.iconBg,
    required this.defaultTitle,
  });
}