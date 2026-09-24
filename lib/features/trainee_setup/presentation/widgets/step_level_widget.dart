import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'level_option_card.dart';

class StepLevelWidget extends StatelessWidget {
  final String selectedLevel;
  final ValueChanged<String> onLevelSelected;

  const StepLevelWidget({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final levels = [
      {
        'key': 'beginner',
        'emoji': '🌱',
        'title': S.of(context).beginner,
        'subtitle': S.of(context).beginnerDesc,
      },
      {
        'key': 'intermediate',
        'emoji': '⚡',
        'title': S.of(context).intermediate,
        'subtitle': S.of(context).intermediateDesc,
      },
      {
        'key': 'advanced',
        'emoji': '🏆',
        'title': S.of(context).advanced,
        'subtitle': S.of(context).advancedDesc,
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            S.of(context).yourLevel,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).levelSubtitle,
            style: TextStyle(
              fontSize: 13.sp,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: levels.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = levels[index];
              final isSelected = selectedLevel == item['key'];
              return LevelOptionCard(
                iconEmoji: item['emoji']!,
                title: item['title']!,
                subtitle: item['subtitle']!,
                isSelected: isSelected,
                onTap: () => onLevelSelected(item['key']!),
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
