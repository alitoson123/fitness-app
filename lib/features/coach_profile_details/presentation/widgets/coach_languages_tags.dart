import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoachLanguagesTags extends StatelessWidget {
  final List<String> languages;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  const CoachLanguagesTags({
    super.key,
    required this.languages,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLanguages = languages.isNotEmpty
        ? languages
        : const ['Arabic', 'English'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.translate_rounded, size: 14.r, color: textSecondary),
            SizedBox(width: 6.w),
            Text(
              S.of(context).spokenLanguages,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: effectiveLanguages.map((lang) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF004D40).withValues(alpha: 0.35)
                    : const Color(0xFFE8F7F5),
                borderRadius: AppRadius.fullAll,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF80CBC4).withValues(alpha: 0.3)
                      : const Color(0xFFB2DFDB),
                  width: 0.8,
                ),
              ),
              child: Text(
                lang,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF80CBC4)
                      : const Color(0xFF00796B),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
