import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';

class PricePerSessionField extends StatelessWidget {
  final double sessionPrice;
  final String currency;
  final ValueChanged<double> onPriceChanged;

  const PricePerSessionField({
    super.key,
    required this.sessionPrice,
    required this.currency,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return AppTextField(
      label: S.of(context).pricePerSession,
      hint: S.of(context).pricePerSessionHint,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Text(
          currency,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
      ),
      suffixIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Text(
          S.of(context).perSessionUnit,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ),
      initialValue:
          sessionPrice > 0 ? sessionPrice.toStringAsFixed(0) : '',
      onChanged: (val) {
        final rate = double.tryParse(val) ?? 0.0;
        onPriceChanged(rate);
      },
    );
  }
}
