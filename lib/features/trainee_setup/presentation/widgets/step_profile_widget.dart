import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'avatar_upload_circle.dart';
import 'gender_pill_selector.dart';

class StepProfileWidget extends StatelessWidget {
  final String? photoUrl;
  final String gender;
  final String location;
  final ValueChanged<String?> onPhotoSelected;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onLocationChanged;

  const StepProfileWidget({
    super.key,
    required this.photoUrl,
    required this.gender,
    required this.location,
    required this.onPhotoSelected,
    required this.onGenderChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            S.of(context).yourProfile,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).addPhotoPrompt,
            style: TextStyle(
              fontSize: 13.sp,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          AvatarUploadCircle(
            photoUrl: photoUrl,
            onPhotoSelected: onPhotoSelected,
          ),
          SizedBox(height: 28.h),
          GenderPillSelector(
            selectedGender: gender,
            onGenderChanged: onGenderChanged,
          ),
          SizedBox(height: 20.h),
          _LocationInputField(
            initialValue: location,
            onChanged: onLocationChanged,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _LocationInputField extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _LocationInputField({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final iconColor = isDark ? AppColors.darkTextTertiary : const Color(0xFF94A3B8);

    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 14.sp,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: S.of(context).cityOrRegionOptional,
        prefixIcon: Icon(
          Icons.location_on_outlined,
          color: iconColor,
          size: 20.r,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}
