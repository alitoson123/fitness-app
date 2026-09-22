import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outlined, text, destructive }
enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;
  final bool loading;
  final Widget? icon;
  final Widget? iconRight;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.fullWidth = false,
    this.loading = false,
    this.icon,
    this.iconRight,
  });

  (double height, double hPadding, TextStyle style) _getDimensions() {
    switch (size) {
      case AppButtonSize.sm:
        return (36.h, 16.w, TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700));
      case AppButtonSize.md:
        return (48.h, 24.w, TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700));
      case AppButtonSize.lg:
        return (56.h, 32.w, TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700));
    }
  }

  (Color bg, Color fg, Color border, List<BoxShadow> shadows, bool hasBorder) _getStyles(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.flameRed : AppColors.primary;
    final primaryDisabled = isDark ? AppColors.flameRed.withValues(alpha: 0.4) : AppColors.primary300;
    final primaryShadow = isDark ? AppShadows.flame : AppShadows.primary;
    final bool disabled = onPressed == null || loading;

    switch (variant) {
      case AppButtonVariant.primary:
        return (
          disabled ? primaryDisabled : primaryColor,
          AppColors.onPrimary,
          Colors.transparent,
          disabled ? [] : primaryShadow,
          false
        );
      case AppButtonVariant.secondary:
        return (
          disabled ? AppColors.secondary : AppColors.secondary,
          AppColors.onSecondary,
          Colors.transparent,
          disabled ? [] : AppShadows.secondary,
          false
        );
      case AppButtonVariant.outlined:
        return (Colors.transparent, primaryColor, primaryColor, [], true);
      case AppButtonVariant.text:
        return (Colors.transparent, primaryColor, Colors.transparent, [], false);
      case AppButtonVariant.destructive:
        return (AppColors.error, Colors.white, Colors.transparent, [], false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (height, hPadding, labelStyle) = _getDimensions();
    final (bg, fg, borderColor, shadows, hasBorder) = _getStyles(context);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 18.r,
            height: 18.r,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
          )
        else ...[
          if (icon != null) ...[icon!, SizedBox(width: AppSpacing.s2)],
          Text(label, style: labelStyle.copyWith(color: fg)),
          if (iconRight != null) ...[SizedBox(width: AppSpacing.s2), iconRight!],
        ],
      ],
    );

    Widget button = Container(
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.fullAll,
        border: hasBorder ? Border.all(color: borderColor, width: 2.w) : null,
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: AppRadius.fullAll,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            child: Center(child: content),
          ),
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
