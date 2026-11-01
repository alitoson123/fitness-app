import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/coach_profile_cubit/coach_profile_cubit.dart';
import 'coach_profile_rate_tile.dart';
import 'edit_pricing_dialog.dart';

class CoachProfilePricingCardWidget extends StatelessWidget {
  final CoachProfileModel profile;

  const CoachProfilePricingCardWidget({super.key, required this.profile});

  void _onEditPricing(BuildContext context) {
    EditPricingDialog.show(
      context,
      profile: profile,
      onSave: (sessionPrice, monthlyPrice) {
        context.read<CoachProfileCubit>().updatePricing(
              sessionPriceUSD: sessionPrice,
              monthlyPriceUSD: monthlyPrice,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.coachPricingCardTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => _onEditPricing(context),
                borderRadius: AppRadius.smAll,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined,
                          size: 14.r, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        s.editPricingAction,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: CoachProfileRateTile(
                  title: s.sessionPricingOptionTitle,
                  rate:
                      '\$${profile.sessionPriceUSD.toStringAsFixed(0)}',
                  subtitle: s.usdBadge,
                  icon: Icons.flash_on_rounded,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CoachProfileRateTile(
                  title: s.monthlyPricingOptionTitle,
                  rate:
                      '\$${profile.monthlyPriceUSD.toStringAsFixed(0)}',
                  subtitle: s.perMonthUnit,
                  icon: Icons.calendar_today_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
