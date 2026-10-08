import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../../generated/l10n.dart';

class AppGenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const AppGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final unselectedBg = isDark ? AppColors.darkSurface : Colors.white;
    final unselectedBorder =
        isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final unselectedText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final options = [
      {'key': 'male', 'label': S.of(context).male, 'icon': Icons.male_rounded},
      {
        'key': 'female',
        'label': S.of(context).female,
        'icon': Icons.female_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).gender,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: options.map((opt) {
            final isSelected = selectedGender == opt['key'];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: opt['key'] == 'male' ? 6.w : 0,
                  left: opt['key'] == 'female' ? 6.w : 0,
                ),
                child: InkWell(
                  onTap: () => onGenderChanged(opt['key'] as String),
                  borderRadius: BorderRadius.circular(12.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? AppColors.flameRedContainer
                              : primary.withValues(alpha: 0.1))
                          : unselectedBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? primary : unselectedBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          opt['icon'] as IconData,
                          size: 18.r,
                          color: isSelected ? primary : unselectedText,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          opt['label'] as String,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected ? primary : unselectedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
