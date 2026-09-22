import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppRating extends StatelessWidget {
  final double value;
  final int reviews;
  final bool compact;

  const AppRating({
    super.key,
    required this.value,
    this.reviews = 0,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final tertiaryTextColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    final starSize = compact ? 14.r : 18.r;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(5, (i) {
            final filled = i < value.floor();
            return Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: const Color(0xFFFBBF24),
              size: starSize,
            );
          }),
        ),
        SizedBox(width: AppSpacing.s1),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
            fontSize: compact ? 12.sp : 13.sp,
            fontWeight: compact ? FontWeight.w600 : FontWeight.w700,
            color: primaryTextColor,
          ),
        ),
        if (reviews > 0) ...[
          SizedBox(width: AppSpacing.s1),
          Text(
            '($reviews)',
            style: TextStyle(
              fontSize: compact ? 11.sp : 12.sp,
              fontWeight: FontWeight.w600,
              color: tertiaryTextColor,
            ),
          ),
        ],
      ],
    );
  }
}
