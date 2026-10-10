import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_gender_selector.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../trainee_setup/presentation/widgets/avatar_upload_circle.dart';
import '../../../../generated/l10n.dart';
import '../helpers/coach_setup_localization_helper.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'country_city_selector.dart';

class StepPersonalInfoWidget extends StatelessWidget {
  final CoachSetupCubit cubit;

  const StepPersonalInfoWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarUploadCircle(
            photoUrl: cubit.photoUrl.isNotEmpty ? cubit.photoUrl : null,
            onPhotoSelected: (url) => cubit.setPhotoUrl(url ?? ''),
          ),
          SizedBox(height: 16.h),
          AppTextField(
            label: S.of(context).fullName,
            hint: S.of(context).fullNameHint,
            initialValue: cubit.name,
            onChanged: cubit.setName,
          ),
          SizedBox(height: 14.h),
          CountryCitySelector(
            selectedCountry: cubit.country,
            selectedCity: cubit.city,
            onCountryChanged: cubit.setCountry,
            onCityChanged: cubit.setCity,
          ),
          SizedBox(height: 14.h),
          AppTextField(
            label: S.of(context).age,
            hint: S.of(context).ageHint,
            keyboardType: TextInputType.number,
            initialValue: cubit.age > 0 ? cubit.age.toString() : '',
            prefixIcon: Icon(Icons.cake_outlined, size: 20.r),
            onChanged: (val) => cubit.setAge(int.tryParse(val.trim()) ?? 0),
          ),
          SizedBox(height: 14.h),
          AppGenderSelector(
            selectedGender: cubit.gender,
            onGenderChanged: cubit.setGender,
          ),
          SizedBox(height: 14.h),
          AppTextField(
            label: S.of(context).bio,
            hint: S.of(context).bioHint,
            initialValue: cubit.bio,
            onChanged: cubit.setBio,
            maxLines: 6,
          ),
          SizedBox(height: 14.h),
          Text(
            S.of(context).languages,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: AppConstants.supportedLanguages.map((lang) {
              final isSelected = cubit.selectedLanguages.contains(lang);
              return AppChip(
                label: CoachSetupLocalizationHelper.getLocalizedLanguage(
                  context,
                  lang,
                ),
                selected: isSelected,
                onTap: () => cubit.toggleLanguage(lang),
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
