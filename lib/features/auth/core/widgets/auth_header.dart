import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final iconGradient = isDark ? AppColors.flameGradient : AppColors.splashGradient;

    return Column(
      children: [
        SizedBox(height: AppSpacing.s4),
        Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: iconGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.xlAll,
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            size: 32.r,
            color: Colors.white,
          ),
        ),
        SizedBox(height: AppSpacing.s4),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.s1),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.s6),
      ],
    );
  }
}
