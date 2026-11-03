import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/widgets/delete_account_dialog.dart';

class TraineeAccountDangerZone extends StatelessWidget {
  const TraineeAccountDangerZone({super.key});

  void _confirmSignOut(BuildContext context) {
    final s = S.of(context);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        title: Text(
          s.confirmSignOutTitle,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
          ),
        ),
        content: Text(
          s.confirmSignOutTraineeMessage,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.darkTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              s.cancel,
              style: const TextStyle(color: AppColors.darkTextSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.flameRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<AuthSessionCubit>().signOut();
            },
            child: Text(s.signOut),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final authCubit = context.read<AuthSessionCubit>();

    return Column(
      children: [
        Material(
          color: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgAll,
            side: const BorderSide(color: AppColors.darkBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
            leading: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: AppColors.darkTextPrimary,
                size: 20.r,
              ),
            ),
            title: Text(
              s.signOut,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.darkTextPrimary,
              ),
            ),
            onTap: () => _confirmSignOut(context),
          ),
        ),
        SizedBox(height: AppSpacing.s2),
        TextButton(
          onPressed: () {
            DeleteAccountDialog.show(
              context,
              onConfirm: () => authCubit.deleteAccount(),
            );
          },
          child: Text(
            s.deleteAccount,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}

