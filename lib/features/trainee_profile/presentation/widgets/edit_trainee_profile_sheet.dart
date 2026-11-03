import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_cubit.dart';
import 'edit_trainee_profile_form_body.dart';
import 'edit_trainee_sheet_header.dart';

class EditTraineeProfileSheet extends StatefulWidget {
  final TraineeProfileModel profile;

  const EditTraineeProfileSheet({super.key, required this.profile});

  static Future<void> show(BuildContext context, TraineeProfileModel profile) {
    final cubit = context.read<TraineeProfileCubit>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditTraineeProfileSheet(profile: profile),
      ),
    );
  }

  @override
  State<EditTraineeProfileSheet> createState() =>
      _EditTraineeProfileSheetState();
}

class _EditTraineeProfileSheetState extends State<EditTraineeProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;
  late final TextEditingController _ageController;
  late String _selectedGender;
  late String _selectedLevel;
  late String _selectedGoal;
  late List<String> _selectedSports;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _countryController = TextEditingController(text: p.country);
    _cityController = TextEditingController(text: p.city);
    _ageController = TextEditingController(text: p.age > 0 ? '${p.age}' : '');
    _selectedGender = p.gender;
    _selectedLevel = p.level.isNotEmpty ? p.level : 'beginner';
    _selectedGoal = p.goal.isNotEmpty ? p.goal : 'fitness';
    _selectedSports = List<String>.from(p.sports);
  }

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _countryController,
      _cityController,
      _ageController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      gender: _selectedGender,
      level: _selectedLevel,
      goal: _selectedGoal,
      sports: _selectedSports,
    );

    context.read<TraineeProfileCubit>().updateProfile(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            const EditTraineeSheetHeader(),
            const Divider(height: 1),
            Expanded(
              child: EditTraineeProfileFormBody(
                formKey: _formKey,
                scrollController: scrollController,
                nameController: _nameController,
                countryController: _countryController,
                cityController: _cityController,
                ageController: _ageController,
                selectedGender: _selectedGender,
                selectedLevel: _selectedLevel,
                selectedGoal: _selectedGoal,
                selectedSports: _selectedSports,
                onGenderChanged: (g) => setState(() => _selectedGender = g),
                onLevelChanged: (l) => setState(() => _selectedLevel = l),
                onGoalChanged: (g) => setState(() => _selectedGoal = g),
                onSportsChanged: (s) => setState(() => _selectedSports = s),
                onSubmit: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
