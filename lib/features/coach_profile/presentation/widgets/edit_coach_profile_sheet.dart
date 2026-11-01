import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/coach_profile_cubit/coach_profile_cubit.dart';
import 'edit_profile_form_body.dart';
import 'edit_profile_sheet_header.dart';

class EditCoachProfileSheet extends StatefulWidget {
  final CoachProfileModel profile;

  const EditCoachProfileSheet({super.key, required this.profile});

  static Future<void> show(BuildContext context, CoachProfileModel profile) {
    final cubit = context.read<CoachProfileCubit>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditCoachProfileSheet(profile: profile),
      ),
    );
  }

  @override
  State<EditCoachProfileSheet> createState() => _EditCoachProfileSheetState();
}

class _EditCoachProfileSheetState extends State<EditCoachProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _experienceController;
  late final TextEditingController _specialtiesController;
  late final TextEditingController _sessionPriceController;
  late final TextEditingController _monthlyPriceController;
  late List<String> _selectedSports;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _bioController = TextEditingController(text: p.bio);
    _experienceController = TextEditingController(
      text: p.yearsOfExperience > 0 ? '${p.yearsOfExperience}' : '',
    );
    _specialtiesController = TextEditingController(
      text: p.specialties.join(', '),
    );
    _sessionPriceController = TextEditingController(
      text: p.sessionPriceUSD > 0 ? p.sessionPriceUSD.toStringAsFixed(0) : '',
    );
    _monthlyPriceController = TextEditingController(
      text: p.monthlyPriceUSD > 0 ? p.monthlyPriceUSD.toStringAsFixed(0) : '',
    );
    _selectedSports = List<String>.from(p.sports);
  }

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _bioController,
      _experienceController,
      _specialtiesController,
      _sessionPriceController,
      _monthlyPriceController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final specs = _specialtiesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      yearsOfExperience: int.tryParse(_experienceController.text.trim()) ?? 0,
      specialties: specs,
      sports: _selectedSports,
      sessionPriceUSD:
          double.tryParse(_sessionPriceController.text.trim()) ?? 0.0,
      monthlyPriceUSD:
          double.tryParse(_monthlyPriceController.text.trim()) ?? 0.0,
    );

    context.read<CoachProfileCubit>().updateProfile(updated);
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
            const EditProfileSheetHeader(),
            const Divider(height: 1),
            Expanded(
              child: EditProfileFormBody(
                formKey: _formKey,
                scrollController: scrollController,
                nameController: _nameController,
                bioController: _bioController,
                experienceController: _experienceController,
                specialtiesController: _specialtiesController,
                sessionPriceController: _sessionPriceController,
                monthlyPriceController: _monthlyPriceController,
                selectedSports: _selectedSports,
                onSportsChanged: (sports) =>
                    setState(() => _selectedSports = sports),
                onSubmit: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
