import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/coach_profile_cubit/coach_profile_cubit.dart';
import 'coach_profile_avatar.dart';
import 'edit_coach_profile_sheet.dart';
import '../../../../core/widgets/photo_picker_bottom_sheet.dart';

class CoachProfileHeaderWidget extends StatelessWidget {
  final CoachProfileModel profile;

  const CoachProfileHeaderWidget({super.key, required this.profile});

  Future<void> _onChangePhoto(BuildContext context) async {
    final file = await PhotoPickerBottomSheet.show(context);
    if (file != null && context.mounted) {
      context.read<CoachProfileCubit>().uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      children: [
        CoachProfileAvatar(
          photoUrl: profile.photoUrl,
          onChangePhoto: () => _onChangePhoto(context),
        ),
        SizedBox(height: AppSpacing.s3),
        _buildVerificationBadge(context),
        SizedBox(height: AppSpacing.s2),
        Text(
          profile.name.isNotEmpty ? profile.name : s.coachProfileTitle,
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
                  sport,
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
          label: s.editCoachProfile,
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.sm,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => EditCoachProfileSheet.show(context, profile),
        ),
      ],
    );
  }

  Widget _buildVerificationBadge(BuildContext context) {
    final s = S.of(context);
    final isApproved = profile.verificationStatus == 'approved';
    final badgeColor = isApproved ? AppColors.success : AppColors.warning;
    final badgeText =
        isApproved ? s.verifiedCoach : s.pendingVerificationBadge;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: AppRadius.fullAll,
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApproved
                ? Icons.verified_rounded
                : Icons.hourglass_top_rounded,
            size: 13.r,
            color: badgeColor,
          ),
          SizedBox(width: 4.w),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}
