import 'package:flutter/material.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_snackbar.dart';

abstract class Message {
  static void showSuccess(BuildContext context, String message) {
    AppSnackbar.show(context, message: message, type: AppSnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    AppSnackbar.show(context, message: message, type: AppSnackbarType.error);
  }

  static void showWarning(BuildContext context, String message) {
    AppSnackbar.show(context, message: message, type: AppSnackbarType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    AppSnackbar.show(context, message: message, type: AppSnackbarType.info);
  }

  static void showAppDialog({
    required BuildContext context,
    required DialogType type,
    required String message,
    String? title,
    String? buttonText,
    bool isVerifyButton = false,
    VoidCallback? onVerifyPressed,
    String? verifyButtonText,
  }) {
    showDialog(
      context: context,
      builder: (_) => AppDialog(
        type: type,
        message: message,
        title: title,
        buttonText: buttonText,
        isVerifyButton: isVerifyButton,
        onVerifyPressed: onVerifyPressed,
        verifyButtonText: verifyButtonText,
      ),
    );
  }
}