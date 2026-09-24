import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigator/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../generated/l10n.dart';
import '../../../core/widgets/auth_header.dart';
import '../../../core/widgets/auth_tab_switcher.dart';
import '../../../core/widgets/social_login_section.dart';
import '../view_model/sign_up_cubit/sign_up_cubit.dart';

class SignUpViewBody extends StatefulWidget {
  final bool isLoading;

  const SignUpViewBody({super.key, required this.isLoading});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<SignUpCubit>().signUpMethod(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(
              title: S.of(context).createAccount,
              subtitle: S.of(context).signUpSubtitle,
            ),
            AuthTabSwitcher(
              isLogin: false,
              onLoginTap: () {
                context.pushReplacement(AppRoutes.signIn);
              },
              onRegisterTap: () {},
            ),
            SizedBox(height: AppSpacing.s6),
            AppTextField(
              controller: _nameController,
              label: S.of(context).fullName,
              hint: S.of(context).fullNameHint,
              prefixIcon: Icon(Icons.person_outline_rounded, size: 20.r),
              validator: (v) => v == null || v.trim().isEmpty
                  ? S.of(context).pleaseEnterName
                  : null,
            ),
            SizedBox(height: AppSpacing.s4),
            AppTextField(
              controller: _emailController,
              label: S.of(context).emailAddress,
              hint: S.of(context).emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.mail_outline_rounded, size: 20.r),
              validator: (v) => v == null || v.trim().isEmpty
                  ? S.of(context).pleaseEnterEmail
                  : null,
            ),
            SizedBox(height: AppSpacing.s4),
            AppTextField(
              controller: _passwordController,
              label: S.of(context).password,
              hint: S.of(context).passwordLengthHint,
              obscureText: _obscurePassword,
              prefixIcon: Icon(Icons.lock_outline_rounded, size: 20.r),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20.r,
                  color: AppColors.textTertiary,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) => v == null || v.length < 6
                  ? S.of(context).passwordMinLength
                  : null,
            ),
            SizedBox(height: AppSpacing.s6),
            AppButton(
              label: S.of(context).createAccount,
              fullWidth: true,
              loading: widget.isLoading,
              onPressed: _onSignUp,
            ),
            SizedBox(height: AppSpacing.s6),
            SocialLoginSection(
              onGooglePressed: () {
                context.pushReplacement(AppRoutes.signIn);
              },
              onApplePressed: () {
                context.pushReplacement(AppRoutes.signIn);
              },
            ),
            SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }
}
