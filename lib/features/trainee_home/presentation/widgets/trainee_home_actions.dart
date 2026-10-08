import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../generated/l10n.dart';
import '../../../auth/core/widgets/delete_account_dialog.dart';

class TraineeHomeActions extends StatelessWidget {
  final bool isLoading;
  final bool isDeleting;
  final VoidCallback onSignOut;
  final VoidCallback onDeleteAccount;

  const TraineeHomeActions({
    super.key,
    required this.isLoading,
    required this.isDeleting,
    required this.onSignOut,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: S.of(context).signOut,
          variant: AppButtonVariant.primary,
          fullWidth: true,
          loading: isLoading && !isDeleting,
          icon: Icon(Icons.logout_rounded, size: 18.r),
          onPressed: isLoading ? null : onSignOut,
        ),
        SizedBox(height: AppSpacing.s3),
        AppButton(
          label: S.of(context).deleteAccount,
          variant: AppButtonVariant.destructive,
          fullWidth: true,
          loading: isLoading && isDeleting,
          icon: Icon(Icons.delete_outline_rounded, size: 18.r),
          onPressed: isLoading
              ? null
              : () => DeleteAccountDialog.show(
                    context,
                    onConfirm: onDeleteAccount,
                  ),
        ),
      ],
    );
  }
}
