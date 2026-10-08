import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CoachStepIndicators extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final ValueChanged<int>? onStepTapped;

  const CoachStepIndicators({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return Expanded(
          child: GestureDetector(
            onTap: isCompleted && onStepTapped != null
                ? () => onStepTapped!(index)
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              height: 5.h,
              decoration: BoxDecoration(
                color: isCompleted
                    ? primary
                    : isActive
                        ? primary
                        : inactiveColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        );
      }),
    );
  }
}
