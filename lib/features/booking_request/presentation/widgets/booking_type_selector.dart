import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'booking_type_card.dart';

class BookingTypeSelector extends StatelessWidget {
  final CoachProfileModel coach;
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const BookingTypeSelector({
    super.key,
    required this.coach,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.bookingTypeLabel,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: BookingTypeCard(
                title: s.singleSessionType,
                priceText: '\$${coach.sessionPriceUSD.toStringAsFixed(0)}',
                subtitle: s.sessionPricingOptionTitle,
                icon: Icons.fitness_center_rounded,
                isSelected: selectedType == 'session',
                onTap: () => onTypeSelected('session'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BookingTypeCard(
                title: s.monthlyPackageType,
                priceText: '\$${coach.monthlyPriceUSD.toStringAsFixed(0)}',
                subtitle: s.perMonthUnit,
                icon: Icons.calendar_month_rounded,
                isSelected: selectedType == 'monthly',
                onTap: () => onTypeSelected('monthly'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
