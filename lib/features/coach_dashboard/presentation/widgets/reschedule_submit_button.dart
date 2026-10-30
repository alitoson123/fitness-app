import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class RescheduleSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final bool isEnabled;
  final VoidCallback? onSubmit;

  const RescheduleSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.isEnabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: FilledButton(
        onPressed: (isEnabled && !isSubmitting) ? onSubmit : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(s.sendRescheduleRequest, style: TextStyle(fontSize: 14.sp)),
      ),
    );
  }
}

