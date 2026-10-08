import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_gender_selector.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/country_city_selector.dart';
import '../../../../generated/l10n.dart';
import '../view_model/trainee_setup_cubit/trainee_setup_cubit.dart';
import 'avatar_upload_circle.dart';

class StepProfileWidget extends StatelessWidget {
  final TraineeSetupCubit cubit;

  const StepProfileWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarUploadCircle(
            photoUrl: cubit.photoUrl != null && cubit.photoUrl!.isNotEmpty
                ? cubit.photoUrl
                : null,
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
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
