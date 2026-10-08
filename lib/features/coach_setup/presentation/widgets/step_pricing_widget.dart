import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'currency_dropdown_field.dart';
import 'price_per_session_field.dart';
import 'pricing_tip_card.dart';

class StepPricingWidget extends StatelessWidget {
  final CoachSetupCubit cubit;

  const StepPricingWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).stepPricing,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).pricingStepSubtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          const PricingTipCard(),
          SizedBox(height: 18.h),
          CurrencyDropdownField(
            selectedCurrency: cubit.currency,
            onCurrencyChanged: cubit.setCurrency,
          ),
          SizedBox(height: 18.h),
          PricePerSessionField(
            sessionPrice: cubit.sessionPrice,
            currency: cubit.currency,
            onPriceChanged: cubit.setSessionPrice,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
