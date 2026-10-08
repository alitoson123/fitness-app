import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';

class CoachActionButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isLoading;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CoachActionButtons({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
    this.isLoading = false,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

    return Row(
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
                ? S.of(context).submitApplication
                : S.of(context).next,
            variant: AppButtonVariant.primary,
            size: AppButtonSize.md,
            loading: isLoading,
            onPressed: isLoading ? null : onNext,
          ),
        ),
      ],
    );
  }
}
