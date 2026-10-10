import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';

class CoachStatusActionButtons extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onSignOut;

  const CoachStatusActionButtons({
    super.key,
    required this.onRefresh,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        AppButton(
          label: s.checkStatusAgain,
          variant: AppButtonVariant.secondary,
          fullWidth: true,
          icon: Icon(Icons.refresh_rounded, size: 18.r),
          onPressed: onRefresh,
        ),
        SizedBox(height: AppSpacing.s3),
        AppButton(
          label: s.signOut,
          variant: AppButtonVariant.outlined,
          fullWidth: true,
          icon: Icon(Icons.logout_rounded, size: 18.r),
          onPressed: onSignOut,
        ),
      ],
    );
  }
}
