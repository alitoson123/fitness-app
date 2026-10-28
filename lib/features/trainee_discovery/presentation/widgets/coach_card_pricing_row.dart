import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

class CoachCardPricingRow extends StatelessWidget {
  final CoachProfileModel coach;
  final Color primaryColor;
  final Color textPrimaryColor;
  final bool isDark;

  const CoachCardPricingRow({
    super.key,
    required this.coach,
    required this.primaryColor,
    required this.textPrimaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final chipBg = isDark
        ? AppColors.darkSurfaceVariant
        : primaryColor.withValues(alpha: 0.08);

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 6.w,
            runSpacing: 4.h,
            children: [
              _buildPriceChip(
                label: S.of(context).sessionPriceChip(
                  coach.sessionPriceUSD.toStringAsFixed(0),
                ),
                chipBg: chipBg,
              ),
              if (coach.monthlyPriceUSD > 0)
                _buildPriceChip(
                  label: S.of(context).monthlyPriceChip(
                    coach.monthlyPriceUSD.toStringAsFixed(0),
                  ),
                  chipBg: chipBg,
                ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 13.r,
          color: textPrimaryColor.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  Widget _buildPriceChip({required String label, required Color chipBg}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.18),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: primaryColor,
        ),
      ),
    );
  }
}

