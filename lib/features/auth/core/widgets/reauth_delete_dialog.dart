import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../phone_sign_in/presentation/widgets/otp_pin_input.dart';
import '../presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../presentation/view_model/auth_session_cubit/auth_session_states.dart';

/// Shown when Firebase needs a fresh SMS confirmation before deleting the
/// account. Sends a code to the user's own number, then deletes on success.
/// The screen listening to [AuthSessionCubit] handles navigation after
/// [AuthSessionDeleteSuccessState]; this dialog just closes itself.
class ReauthDeleteDialog extends StatefulWidget {
  const ReauthDeleteDialog({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<AuthSessionCubit>();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const ReauthDeleteDialog(),
      ),
    );
  }

  @override
  State<ReauthDeleteDialog> createState() => _ReauthDeleteDialogState();
}

class _ReauthDeleteDialogState extends State<ReauthDeleteDialog> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthSessionCubit>().sendReauthCode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _codeController.text.trim();
    if (code.length != 6) return;
    context.read<AuthSessionCubit>().confirmReauthAndDelete(code);
  }

  void _cancel() {
    context.read<AuthSessionCubit>().cancelReauth();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final phone =
        context.read<AuthSessionCubit>().currentUserPhoneNumber ?? '';

    return BlocConsumer<AuthSessionCubit, AuthSessionStates>(
      listener: (context, state) {
        if (state is AuthSessionDeleteSuccessState ||
            state is AuthSessionErrorState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final reauth = state is AuthSessionReauthState ? state : null;
        final isSending = reauth?.isSendingCode ?? false;
        final isVerifying = reauth?.isVerifying ?? false;
        final canEnterCode = reauth?.verificationId != null;

        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
            backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
            insetPadding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.confirmDeletionTitle,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.s2),
                    Text(
                      isSending
                          ? s.sendingCode
                          : s.confirmDeletionMessage(phone),
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.4,
                        color: textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.s4),
                    if (canEnterCode)
                      FittedBox(
                        child: OtpPinInput(
                          controller: _codeController,
                          onCompleted: (_) => _submit(),
                        ),
                      )
                    else if (isSending)
                      const CircularProgressIndicator(),
                    if (reauth?.errorMessage != null) ...[
                      SizedBox(height: AppSpacing.s3),
                      Text(
                        reauth!.errorMessage!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    SizedBox(height: AppSpacing.s6),
                    if (canEnterCode)
                      AppButton(
                        label: s.deleteAccountConfirm,
                        variant: AppButtonVariant.destructive,
                        fullWidth: true,
                        loading: isVerifying,
                        onPressed: isVerifying ? null : _submit,
                      )
                    else if (!isSending)
                      AppButton(
                        label: s.tryAgain,
                        fullWidth: true,
                        onPressed: () => context
                            .read<AuthSessionCubit>()
                            .sendReauthCode(),
                      ),
                    SizedBox(height: AppSpacing.s3),
                    AppButton(
                      label: s.cancel,
                      variant: AppButtonVariant.outlined,
                      fullWidth: true,
                      onPressed: isVerifying ? null : _cancel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
