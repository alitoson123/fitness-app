import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';
import '../theme/app_colors.dart';
import 'app_text_field.dart';

class OtherSportInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const OtherSportInputField({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return AppTextField(
      controller: controller,
      hint: s.enterOtherSport,
      prefixIcon: Icon(Icons.sports_rounded, size: 20.r, color: primary),
      suffixIcon: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          margin: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16.r, color: Colors.white),
              SizedBox(width: 4.w),
              Text(
                s.addSport,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      onFieldSubmitted: (_) => onAdd(),
    );
  }
}
