import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class BookingNotesField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const BookingNotesField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final fieldBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).additionalNotesOptional,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          maxLines: 3,
          style: TextStyle(fontSize: 13.sp, color: textPrimary),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: S.of(context).bookingNotesPlaceholder,
            hintStyle: TextStyle(fontSize: 13.sp, color: textSecondary),
            filled: true,
            fillColor: fieldBg,
            contentPadding: EdgeInsets.all(12.r),
            border: OutlineInputBorder(
              borderRadius: AppRadius.mdAll,
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.mdAll,
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.mdAll,
              borderSide: BorderSide(
                color: isDark ? AppColors.flameRed : AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
