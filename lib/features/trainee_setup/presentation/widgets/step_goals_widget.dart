import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'goal_option_card.dart';

class StepGoalsWidget extends StatelessWidget {
  final String selectedGoal;
  final ValueChanged<String> onGoalSelected;

  const StepGoalsWidget({
    super.key,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final goals = [
      {'key': 'fitness', 'emoji': '💪', 'title': S.of(context).generalFitness},
      {'key': 'weight_loss', 'emoji': '⚡', 'title': S.of(context).weightLoss},
      {'key': 'competition', 'emoji': '🏆', 'title': S.of(context).competitionPrep},
      {'key': 'skill', 'emoji': '🎯', 'title': S.of(context).skillDevelopment},
      {'key': 'fun', 'emoji': '😊', 'title': S.of(context).funRecreation},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            S.of(context).yourGoal,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).goalSubtitle,
            style: TextStyle(
              fontSize: 13.sp,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: goals.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final item = goals[index];
              final isSelected = selectedGoal == item['key'];
              return GoalOptionCard(
                iconEmoji: item['emoji']!,
                title: item['title']!,
                isSelected: isSelected,
                onTap: () => onGoalSelected(item['key']!),
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
