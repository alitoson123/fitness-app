import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/widgets/delete_account_dialog.dart';

class TraineeProfileActions extends StatelessWidget {
  const TraineeProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final authCubit = context.read<AuthSessionCubit>();

    return Column(
      children: [
        /*AppButton(
          label: s.editProfile,
          variant: AppButtonVariant.primary,
          fullWidth: true,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => context.push(AppRoutes.traineeSetup),
        ),*/
        SizedBox(height: AppSpacing.s3),
        AppButton(
          label: s.signOut,
          variant: AppButtonVariant.outlined,
          fullWidth: true,
          icon: const Icon(Icons.logout_rounded),
          onPressed: () => authCubit.signOut(),
        ),
        SizedBox(height: AppSpacing.s3),
        AppButton(
          label: s.deleteAccount,
          variant: AppButtonVariant.destructive,
          fullWidth: true,
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () {
            DeleteAccountDialog.show(
              context,
              onConfirm: () => authCubit.deleteAccount(),
            );
          },
        ),
      ],
    );
  }
}
