import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class AuthTabSwitcher extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const AuthTabSwitcher({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.neutral100,
        borderRadius: AppRadius.fullAll,
        border: isDark ? Border.all(color: AppColors.darkBorder, width: 1.w) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: S.of(context).signIn,
              isSelected: isLogin,
              onTap: onLoginTap,
            ),
          ),
          Expanded(
            child: _TabButton(
              label: S.of(context).signUp,
              isSelected: !isLogin,
              onTap: onRegisterTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedBg = isDark ? AppColors.flameRed : Colors.white;
    final selectedTextColor = isDark ? Colors.white : AppColors.textPrimary;
    final unselectedTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: AppRadius.fullAll,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: isDark ? const Color(0x4DFF3D00) : const Color(0x140F172A),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? selectedTextColor : unselectedTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
