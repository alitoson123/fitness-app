import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class EditTraineeSportsChips extends StatelessWidget {
  final List<String> selectedSports;
  final ValueChanged<List<String>> onChanged;

  const EditTraineeSportsChips({
    super.key,
    required this.selectedSports,
    required this.onChanged,
  });

  String _normalize(String s) => s.toLowerCase().replaceAll(' ', '_').trim();

  void _toggle(String key) {
    final list = List<String>.from(selectedSports);
    final target = _normalize(key);
    final index = list.indexWhere((s) => _normalize(s) == target);

    if (index >= 0) {
      if (list.length > 1) {
        list.removeAt(index);
        onChanged(list);
      }
    } else {
      list.add(key);
      onChanged(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sportsList = [
      {'key': 'football', 'label': s.sportFootball},
      {'key': 'basketball', 'label': s.sportBasketball},
      {'key': 'swimming', 'label': s.sportSwimming},
      {'key': 'tennis', 'label': s.sportTennis},
      {'key': 'running', 'label': s.sportRunning},
      {'key': 'boxing', 'label': s.sportBoxing},
      {'key': 'gym', 'label': s.sportGym},
      {'key': 'cycling', 'label': s.sportCycling},
      {'key': 'yoga', 'label': s.sportYoga},
      {'key': 'martial_arts', 'label': s.sportMartialArts},
      {'key': 'volleyball', 'label': s.sportVolleyball},
      {'key': 'other', 'label': s.sportOther},
    ];

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
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: sportsList.map((sport) {
            final key = sport['key']!;
            final isSelected = selectedSports.any(
              (s) => _normalize(s) == key,
            );
            return ChoiceChip(
              label: Text(sport['label']!),
              selected: isSelected,
              onSelected: (_) => _toggle(key),
              selectedColor: AppColors.primary,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
            );
          }).toList(),
        ),
      ],
    );
  }
}
