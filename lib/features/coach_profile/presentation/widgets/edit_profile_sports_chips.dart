import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_sports.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/sports_selector_widget.dart';
import '../../../../generated/l10n.dart';

class EditProfileSportsChips extends StatelessWidget {
  final List<String> selectedSports;
  final ValueChanged<List<String>> onChanged;

  const EditProfileSportsChips({
    super.key,
    required this.selectedSports,
    required this.onChanged,
  });

  void _toggle(String sport) {
    final list = List<String>.from(selectedSports);
    final target = AppSports.normalize(sport);
    final index = list.indexWhere((s) => AppSports.normalize(s) == target);
    if (index >= 0) {
      if (list.length > 1) {
        list.removeAt(index);
        onChanged(list);
      }
    } else {
      list.add(sport);
      onChanged(list);
    }
  }

  void _addCustom(String sport) {
    final trimmed = sport.trim();
    if (trimmed.isEmpty) return;
    final target = AppSports.normalize(trimmed);
    if (!selectedSports.any((s) => AppSports.normalize(s) == target)) {
      onChanged(List<String>.from(selectedSports)..add(trimmed));
    }
  }

  void _removeCustom(String sport) {
    if (selectedSports.length > 1) {
      final target = AppSports.normalize(sport);
      onChanged(
        selectedSports.where((s) => AppSports.normalize(s) != target).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.selectSportsPrompt,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        SportsSelectorWidget(
          selectedSports: selectedSports,
          onSportToggled: _toggle,
          onCustomSportAdded: _addCustom,
          onCustomSportRemoved: _removeCustom,
        ),
      ],
    );
  }
}
