import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/helpers/phone_number_helper.dart';
import 'package:fitness_app/generated/l10n.dart';

class PhoneNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final SupportedCountry selectedCountry;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const PhoneNumberTextField({
    super.key,
    required this.controller,
    required this.selectedCountry,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = S.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLength: selectedCountry.maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        counterText: '',
        hintText: selectedCountry.hintText,
        labelText: s.phoneNumber,
        filled: true,
        fillColor: isDark ? const Color(0xFF1C1C22) : const Color(0xFFF8FAFC),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        prefixIcon: Icon(Icons.phone_outlined, size: 20.r),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.clear_rounded, size: 18.r),
              onPressed: () {
                controller.clear();
                onChanged?.call('');
              },
            );
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2C2C35) : const Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2C2C35) : const Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
