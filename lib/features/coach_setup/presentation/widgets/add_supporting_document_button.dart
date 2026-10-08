import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class AddSupportingDocumentButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddSupportingDocumentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.3)
              : AppColors.surfaceVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: primary.withValues(alpha: 0.5),
            style: BorderStyle.solid,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              size: 18.r,
              color: primary,
            ),
            SizedBox(width: 8.w),
            Text(
              S.of(context).addSupportingDocument,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
