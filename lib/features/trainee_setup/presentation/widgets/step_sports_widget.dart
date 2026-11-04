import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/sports_selector_widget.dart';
import '../../../../generated/l10n.dart';

class StepSportsWidget extends StatelessWidget {
  final List<String> selectedSports;
  final ValueChanged<String> onSportToggled;
  final ValueChanged<String> onCustomSportAdded;
  final ValueChanged<String> onCustomSportRemoved;

  const StepSportsWidget({
    super.key,
    required this.selectedSports,
    required this.onSportToggled,
    required this.onCustomSportAdded,
    required this.onCustomSportRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            S.of(context).yourSports,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).selectSportsSubtitle,
            style: TextStyle(
              fontSize: 13.sp,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          SportsSelectorWidget(
            selectedSports: selectedSports,
            onSportToggled: onSportToggled,
            onCustomSportAdded: onCustomSportAdded,
            onCustomSportRemoved: onCustomSportRemoved,
          ),
          SizedBox(height: 24.h),
          _SportsCountBadge(count: selectedSports.length),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _SportsCountBadge extends StatelessWidget {
  final int count;

  const _SportsCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
      ),
      child: Text(
        S.of(context).sportsSelected(count),
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
      ),
    );
  }
}
