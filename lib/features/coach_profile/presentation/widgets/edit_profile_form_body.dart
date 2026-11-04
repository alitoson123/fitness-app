import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/sport_location_model.dart';
import 'edit_profile_form_fields.dart';
import 'edit_profile_sports_chips.dart';
import 'edit_sport_locations_section.dart';

class EditProfileFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ScrollController scrollController;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController experienceController;
  final TextEditingController specialtiesController;
  final TextEditingController sessionPriceController;
  final TextEditingController monthlyPriceController;
  final List<String> selectedSports;
  final List<SportLocationModel> sportLocations;
  final ValueChanged<List<String>> onSportsChanged;
  final ValueChanged<List<SportLocationModel>> onLocationsChanged;
  final VoidCallback onSubmit;

  const EditProfileFormBody({
    super.key,
    required this.formKey,
    required this.scrollController,
    required this.nameController,
    required this.bioController,
    required this.experienceController,
    required this.specialtiesController,
    required this.sessionPriceController,
    required this.monthlyPriceController,
    required this.selectedSports,
    required this.sportLocations,
    required this.onSportsChanged,
    required this.onLocationsChanged,
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
          EditProfileFormFields(
            nameController: nameController,
            bioController: bioController,
            experienceController: experienceController,
            specialtiesController: specialtiesController,
            sessionPriceController: sessionPriceController,
            monthlyPriceController: monthlyPriceController,
          ),
          SizedBox(height: AppSpacing.s3),
          EditProfileSportsChips(
            selectedSports: selectedSports,
            onChanged: onSportsChanged,
          ),
          SizedBox(height: AppSpacing.s3),
          EditSportLocationsSection(
            sports: selectedSports,
            sportLocations: sportLocations,
            onLocationsChanged: onLocationsChanged,
          ),
          SizedBox(height: AppSpacing.s5),
          AppButton(
            label: S.of(context).saveChanges,
            onPressed: onSubmit,
          ),
          SizedBox(height: AppSpacing.s4),
        ],
      ),
    );
  }
}

