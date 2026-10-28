import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'coach_pricing_option_tile.dart';

class CoachPricingCard extends StatelessWidget {
  final CoachProfileModel coach;

  const CoachPricingCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).sessionPricing,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          CoachPricingOptionTile(
            icon: Icons.timer_outlined,
            title: S.of(context).sessionPricingOptionTitle,
            priceText: '\$${coach.sessionPriceUSD.toStringAsFixed(0)}',
            unitText: S.of(context).perSessionUnit,
            description: S.of(context).sessionPricingOptionDesc,
            isHighlighted: false,
          ),
          if (coach.monthlyPriceUSD > 0) ...[
            SizedBox(height: 10.h),
            CoachPricingOptionTile(
              icon: Icons.calendar_month_rounded,
              title: S.of(context).monthlyPricingOptionTitle,
              priceText: '\$${coach.monthlyPriceUSD.toStringAsFixed(0)}',
              unitText: S.of(context).perMonthUnit,
              description: S.of(context).monthlyPricingOptionDesc,
              isHighlighted: true,
            ),
          ],
        ],
      ),
    );
  }
}
