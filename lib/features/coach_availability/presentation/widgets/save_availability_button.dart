import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';

class SaveAvailabilityButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;

  const SaveAvailabilityButton({
    super.key,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: isLoading
          ? S.of(context).savingAvailability
          : S.of(context).saveAvailability,
      variant: AppButtonVariant.primary,
      fullWidth: true,
      loading: isLoading,
      icon: Icon(Icons.check_circle_outline_rounded, size: 18.r),
      onPressed: isLoading ? null : onSave,
    );
  }
}
