import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';
import '../helpers/coach_setup_localization_helper.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'experience_option_card.dart';

class StepProfessionalInfoWidget extends StatelessWidget {
  final CoachSetupCubit cubit;

  const StepProfessionalInfoWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).sportsAndSpecialties,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).selectSportsYouCoach,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: AppConstants.sports.map((sport) {
              final isSelected = cubit.selectedSports.contains(sport);
              return AppChip(
                label: CoachSetupLocalizationHelper.getLocalizedSport(
                  context,
                  sport,
                ),
                selected: isSelected,
                onTap: () => cubit.toggleSport(sport),
              );
            }).toList(),
          ),
          SizedBox(height: 18.h),
          AppTextField(
            label: S.of(context).specialties,
            hint: S.of(context).specialtiesHint,
            initialValue: cubit.specialties.join(', '),
            onChanged: (val) {
              final tags = val
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              cubit.setSpecialties(tags);
            },
          ),
          SizedBox(height: 18.h),
          Text(
            S.of(context).yearsOfExperience,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [1, 2, 3, 4, 5, 6].map((yrs) {
              return ExperienceOptionCard(
                years: yrs,
                isSelected: cubit.yearsOfExperience == yrs,
                isDark: isDark,
                primaryColor: primary,
                onTap: () => cubit.setExperience(yrs),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [7, 8, 9, 10, 15].map((yrs) {
              return ExperienceOptionCard(
                years: yrs,
                isSelected: cubit.yearsOfExperience == yrs,
                isDark: isDark,
                primaryColor: primary,
                onTap: () => cubit.setExperience(yrs),
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
