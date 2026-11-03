import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';
import 'edit_trainee_gender_selector.dart';

class EditTraineeProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController ageController;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const EditTraineeProfileFormFields({
    super.key,
    required this.nameController,
    required this.countryController,
    required this.cityController,
    required this.ageController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: nameController,
          label: s.fullName,
          hint: s.fullNameHint,
          prefixIcon: const Icon(Icons.person_outline_rounded),
          validator: (val) => (val == null || val.trim().isEmpty)
              ? s.validationNameRequired
              : null,
        ),
        SizedBox(height: AppSpacing.s3),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: countryController,
                label: s.country,
                hint: s.countryHint,
                prefixIcon: const Icon(Icons.public_rounded),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AppTextField(
                controller: cityController,
                label: s.city,
                hint: s.cityHint,
                prefixIcon: const Icon(Icons.location_city_rounded),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.s3),
        AppTextField(
          controller: ageController,
          label: s.reviewAge,
          hint: s.ageHint,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.cake_outlined),
          validator: (val) {
            if (val == null || val.trim().isEmpty) return null;
            final n = int.tryParse(val.trim());
            return (n == null || n < 10 || n > 100)
                ? s.validationAgeRequired
                : null;
          },
        ),
        SizedBox(height: AppSpacing.s3),
        EditTraineeGenderSelector(
          selectedGender: selectedGender,
          onGenderChanged: onGenderChanged,
        ),
      ],
    );
  }
}
