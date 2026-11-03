import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/photo_picker_bottom_sheet.dart';
import '../../../../generated/l10n.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_cubit.dart';
import 'edit_trainee_profile_sheet.dart';
import 'trainee_profile_avatar.dart';
import 'trainee_profile_formatters.dart';

class TraineeProfileHeaderWidget extends StatelessWidget {
  final TraineeProfileModel profile;

  const TraineeProfileHeaderWidget({super.key, required this.profile});

  Future<void> _onChangePhoto(BuildContext context) async {
    final file = await PhotoPickerBottomSheet.show(context);
    if (file != null && context.mounted) {
      context.read<TraineeProfileCubit>().uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final locationParts = [
      if (profile.city.isNotEmpty) profile.city,
      if (profile.country.isNotEmpty) profile.country,
    ];
    final locationText = locationParts.join(', ');

    return Column(
      children: [
        TraineeProfileAvatar(
          photoUrl: profile.photoUrl,
          onChangePhoto: () => _onChangePhoto(context),
        ),
        SizedBox(height: AppSpacing.s3),
        Text(
          profile.name.isNotEmpty ? profile.name : s.traineeProfileTitle,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        if (profile.phoneNumber.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone_rounded, size: 14.r, color: textSecondary),
              SizedBox(width: 4.w),
              Text(
                profile.phoneNumber,
                style: TextStyle(fontSize: 13.sp, color: textSecondary),
              ),
            ],
          ),
        ],
        if (locationText.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.r,
                color: textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                locationText,
                style: TextStyle(fontSize: 13.sp, color: textSecondary),
              ),
            ],
          ),
        ],
        if (profile.sports.isNotEmpty) ...[
          SizedBox(height: AppSpacing.s3),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            alignment: WrapAlignment.center,
            children: profile.sports.map((sport) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: AppRadius.fullAll,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  TraineeProfileFormatters.formatSport(context, sport),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        SizedBox(height: AppSpacing.s4),
        AppButton(
          label: s.editProfile,
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.sm,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => EditTraineeProfileSheet.show(context, profile),
        ),
      ],
    );
  }
}
