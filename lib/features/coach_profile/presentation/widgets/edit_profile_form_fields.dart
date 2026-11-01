import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController experienceController;
  final TextEditingController specialtiesController;
  final TextEditingController sessionPriceController;
  final TextEditingController monthlyPriceController;

  const EditProfileFormFields({
    super.key,
    required this.nameController,
    required this.bioController,
    required this.experienceController,
    required this.specialtiesController,
    required this.sessionPriceController,
    required this.monthlyPriceController,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        AppTextField(
          controller: nameController,
          label: s.fullName,
          hint: s.fullNameHint,
          prefixIcon: const Icon(Icons.person_outline_rounded),
          validator: (val) =>
              (val == null || val.trim().isEmpty)
                  ? s.validationNameRequired
                  : null,
        ),
        SizedBox(height: AppSpacing.s3),
        AppTextField(
          controller: bioController,
          label: s.bio,
          hint: s.bioHint,
          maxLines: 3,
          prefixIcon: const Icon(Icons.article_outlined),
        ),
        SizedBox(height: AppSpacing.s3),
        AppTextField(
          controller: experienceController,
          label: s.yearsOfExperienceLabel,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.work_history_outlined),
        ),
        SizedBox(height: AppSpacing.s3),
        AppTextField(
          controller: specialtiesController,
          label: s.specialtiesLabel,
          hint: s.specialtiesHint,
          prefixIcon: const Icon(Icons.stars_outlined),
        ),
        SizedBox(height: AppSpacing.s3),
        AppTextField(
          controller: sessionPriceController,
          label: s.singleSessionPriceUSD,
          hint: s.singleSessionPriceUSDHint,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixIcon: const Icon(Icons.attach_money_rounded),
          validator: (val) {
            final n = double.tryParse(val ?? '');
            return (n == null || n <= 0)
                ? s.validationSessionPriceRequired
                : null;
          },
        ),
        SizedBox(height: AppSpacing.s3),
        AppTextField(
          controller: monthlyPriceController,
          label: s.monthlyPriceUSD,
          hint: s.monthlyPriceUSDHint,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixIcon: const Icon(Icons.calendar_month_rounded),
          validator: (val) {
            final n = double.tryParse(val ?? '');
            return (n == null || n <= 0)
                ? s.validationMonthlyPriceRequired
                : null;
          },
        ),
      ],
    );
  }
}
