import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../generated/l10n.dart';
import '../../../core/widgets/auth_header.dart';
import '../view_model/forget_password_cubit/forget_password_cubit.dart';

class ForgetPasswordViewBody extends StatefulWidget {
  final bool isLoading;

  const ForgetPasswordViewBody({super.key, required this.isLoading});

  @override
  State<ForgetPasswordViewBody> createState() => _ForgetPasswordViewBodyState();
}

class _ForgetPasswordViewBodyState extends State<ForgetPasswordViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordCubit>().forgetPasswordMethod(
            email: _emailController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(
              title: S.of(context).resetPassword,
              subtitle: S.of(context).resetPasswordSubtitle,
            ),
            SizedBox(height: AppSpacing.s4),
            AppTextField(
              controller: _emailController,
              label: S.of(context).emailAddress,
              hint: S.of(context).emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.mail_outline_rounded, size: 20.r),
              validator: (v) => v == null || v.trim().isEmpty ? S.of(context).pleaseEnterEmail : null,
            ),
            SizedBox(height: AppSpacing.s6),
            AppButton(
              label: S.of(context).sendResetLink,
              fullWidth: true,
              loading: widget.isLoading,
              onPressed: _onResetPassword,
            ),
            SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }
}
