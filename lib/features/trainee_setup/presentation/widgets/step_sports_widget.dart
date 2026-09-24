import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'sport_chip_item.dart';

class StepSportsWidget extends StatelessWidget {
  final List<String> selectedSports;
  final ValueChanged<String> onSportToggled;

  const StepSportsWidget({
    super.key,
    required this.selectedSports,
    required this.onSportToggled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final sportsList = [
      {'key': 'football', 'emoji': '⚽', 'label': S.of(context).sportFootball},
      {'key': 'basketball', 'emoji': '🏀', 'label': S.of(context).sportBasketball},
      {'key': 'swimming', 'emoji': '🏊', 'label': S.of(context).sportSwimming},
      {'key': 'tennis', 'emoji': '🎾', 'label': S.of(context).sportTennis},
      {'key': 'running', 'emoji': '🏃', 'label': S.of(context).sportRunning},
      {'key': 'boxing', 'emoji': '🥊', 'label': S.of(context).sportBoxing},
      {'key': 'gym', 'emoji': '🏋️', 'label': S.of(context).sportGym},
      {'key': 'cycling', 'emoji': '🚴', 'label': S.of(context).sportCycling},
      {'key': 'yoga', 'emoji': '🧘', 'label': S.of(context).sportYoga},
      {'key': 'martial_arts', 'emoji': '🥋', 'label': S.of(context).sportMartialArts},
      {'key': 'volleyball', 'emoji': '🏐', 'label': S.of(context).sportVolleyball},
      {'key': 'other', 'emoji': '+', 'label': S.of(context).sportOther},
    ];

    return SingleChildScrollView(
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
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: sportsList.map((sport) {
              final isSelected = selectedSports.contains(sport['key']);
              return SportChipItem(
                emoji: sport['emoji']!,
                label: sport['label']!,
                isSelected: isSelected,
                onTap: () => onSportToggled(sport['key']!),
              );
            }).toList(),
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
        color: isDark ? AppColors.darkSurface : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFBFDBFE),
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
