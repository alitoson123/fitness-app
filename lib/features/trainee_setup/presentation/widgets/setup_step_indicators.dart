import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class SetupStepIndicators extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SetupStepIndicators({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              color: isActive
                  ? (isDark ? AppColors.flameRed : Colors.white)
                  : Colors.white.withValues(alpha: isDark ? 0.18 : 0.35),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: (isDark ? AppColors.flameRed : Colors.white)
                            .withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      )
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
