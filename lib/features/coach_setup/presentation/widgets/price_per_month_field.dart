import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';

class PricePerMonthField extends StatelessWidget {
  final double monthlyPrice;
  final ValueChanged<double> onPriceChanged;

  const PricePerMonthField({
    super.key,
    required this.monthlyPrice,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: S.of(context).monthlyPriceUSD,
          hint: S.of(context).monthlyPriceUSDHint,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Text(
              '\$ USD',
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
              S.of(context).perMonthUnit,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          initialValue: monthlyPrice > 0 ? monthlyPrice.toStringAsFixed(0) : '',
          onChanged: (val) {
            final rate = double.tryParse(val) ?? 0.0;
            onPriceChanged(rate);
          },
        ),
        SizedBox(height: 4.h),
        Text(
          S.of(context).monthlyPriceUSDDesc,
          style: TextStyle(
            fontSize: 11.sp,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
