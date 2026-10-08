import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';
import 'app_text_field.dart';

class CountryCitySelector extends StatelessWidget {
  final String selectedCountry;
  final String selectedCity;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onCityChanged;

  const CountryCitySelector({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
    required this.onCountryChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppTextField(
            label: S.of(context).country,
            hint: S.of(context).countryHint,
            initialValue: selectedCountry,
            prefixIcon: Icon(Icons.public_rounded, size: 20.r),
            onChanged: onCountryChanged,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppTextField(
            label: S.of(context).city,
            hint: S.of(context).cityHint,
            initialValue: selectedCity,
            prefixIcon: Icon(Icons.location_city_rounded, size: 20.r),
            onChanged: onCityChanged,
          ),
        ),
      ],
    );
  }
}
