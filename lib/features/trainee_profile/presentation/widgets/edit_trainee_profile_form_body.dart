import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import 'edit_trainee_fitness_fields.dart';
import 'edit_trainee_profile_form_fields.dart';
import 'edit_trainee_sports_chips.dart';

class EditTraineeProfileFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ScrollController scrollController;
  final TextEditingController nameController;
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController ageController;
  final String selectedGender;
  final String selectedLevel;
  final String selectedGoal;
  final List<String> selectedSports;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onGoalChanged;
  final ValueChanged<List<String>> onSportsChanged;
  final VoidCallback onSubmit;

  const EditTraineeProfileFormBody({
    super.key,
    required this.formKey,
    required this.scrollController,
    required this.nameController,
    required this.countryController,
    required this.cityController,
    required this.ageController,
    required this.selectedGender,
    required this.selectedLevel,
    required this.selectedGoal,
    required this.selectedSports,
    required this.onGenderChanged,
    required this.onLevelChanged,
    required this.onGoalChanged,
    required this.onSportsChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.all(16.r),
        children: [
          EditTraineeProfileFormFields(
            nameController: nameController,
            countryController: countryController,
            cityController: cityController,
            ageController: ageController,
            selectedGender: selectedGender,
            onGenderChanged: onGenderChanged,
          ),
          SizedBox(height: AppSpacing.s3),
          EditTraineeFitnessFields(
            selectedLevel: selectedLevel,
            selectedGoal: selectedGoal,
            onLevelChanged: onLevelChanged,
            onGoalChanged: onGoalChanged,
          ),
          SizedBox(height: AppSpacing.s3),
          EditTraineeSportsChips(
            selectedSports: selectedSports,
            onChanged: onSportsChanged,
          ),
          SizedBox(height: AppSpacing.s5),
          AppButton(label: S.of(context).saveChanges, onPressed: onSubmit),
          SizedBox(height: AppSpacing.s4),
        ],
      ),
    );
  }
}
