import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class CurrencyDropdownField extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;

  static const List<String> supportedCurrencies = [
    'USD',
    'SAR',
    'EUR',
    'AED',
    'EGP',
    'KWD',
    'QAR',
    'BHD',
    'OMR',
    'JOD',
  ];

  const CurrencyDropdownField({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).currency,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: supportedCurrencies.contains(selectedCurrency)
                  ? selectedCurrency
                  : supportedCurrencies.first,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              items: supportedCurrencies.map((c) {
                final isSelected = c == selectedCurrency;
                return DropdownMenuItem<String>(
                  value: c,
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? primary
                          : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  onCurrencyChanged(val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
