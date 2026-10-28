import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/helpers/phone_number_helper.dart';
import 'package:fitness_app/generated/l10n.dart';

class CountryCodeDropdown extends StatelessWidget {
  final SupportedCountry selectedCountry;
  final ValueChanged<SupportedCountry> onCountryChanged;

  const CountryCodeDropdown({
    super.key,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => _showCountryPicker(context),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C22) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? const Color(0xFF2C2C35) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedCountry.flag, style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 6.w),
            Text(
              selectedCountry.countryCode,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.r,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    final s = S.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(80),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Text(
                  s.selectCountry,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                ...SupportedCountry.values.map((country) {
                  final isSelected = country == selectedCountry;
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                    leading: Text(country.flag, style: TextStyle(fontSize: 24.sp)),
                    title: Text(
                      country.localizedName(isArabic),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      country.countryCode,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      onCountryChanged(country);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
