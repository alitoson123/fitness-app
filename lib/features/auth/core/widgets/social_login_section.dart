import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  const SocialLoginSection({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.border;
    final hintColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    final appleIconColor = isDark ? Colors.white : AppColors.neutral900;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: dividerColor)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s3),
              child: Text(
                S.of(context).orContinueWith,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: hintColor,
                ),
              ),
            ),
            Expanded(child: Divider(color: dividerColor)),
          ],
        ),
        SizedBox(height: AppSpacing.s4),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                icon: Icons.g_mobiledata_rounded,
                label: S.of(context).google,
                iconColor: const Color(0xFFEA4335),
                onTap: onGooglePressed,
              ),
            ),
            SizedBox(width: AppSpacing.s3),
            Expanded(
              child: _SocialButton(
                icon: Icons.apple_rounded,
                label: S.of(context).apple,
                iconColor: appleIconColor,
                onTap: onApplePressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.neutral0;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.fullAll,
        border: Border.all(color: borderColor, width: 1.5.w),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.fullAll,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 24.r),
              SizedBox(width: AppSpacing.s2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
