import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';

class SetupActionButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isLoading;
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const SetupActionButtons({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    required this.isLoading,
    required this.onContinue,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: AppButton(
                  label: S.of(context).back,
                  variant: AppButtonVariant.outlined,
                  size: AppButtonSize.md,
                  onPressed: isLoading ? null : onBack,
                ),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              flex: 2,
              child: AppButton(
                label: isLastStep
                    ? S.of(context).completeProfile
                    : S.of(context).next,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.md,
                loading: isLoading,
                onPressed: isLoading ? null : onContinue,
              ),
            ),
          ],
        ),
        if (currentStep != 0)
          Column(
            children: [
              SizedBox(height: 6.h),
              TextButton(
                onPressed: isLoading ? null : onSkip,
                child: Text(
                  S.of(context).skipForNow,
                  style: TextStyle(fontSize: 13.sp, color: textSecondary),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
