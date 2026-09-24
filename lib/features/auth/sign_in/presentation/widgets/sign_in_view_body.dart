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
import '../view_model/sign_in_cubit/sign_in_cubit.dart';

class SignInViewBody extends StatefulWidget {
  final bool isLoading;
  final (String email, String password)? initialParams;

  const SignInViewBody({
    super.key,
    required this.isLoading,
    this.initialParams,
  });

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.initialParams?.$1 ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.initialParams?.$2 ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<SignInCubit>().signInMethod(
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
              title: S.of(context).welcomeBack,
              subtitle: S.of(context).signInSubtitle,
            ),
            AuthTabSwitcher(
              isLogin: true,
              onLoginTap: () {},
              onRegisterTap: () {
                context.pushReplacement(AppRoutes.signUp);
              },
            ),
            SizedBox(height: AppSpacing.s6),
            AppTextField(
              controller: _emailController,
              label: S.of(context).emailAddress,
              hint: S.of(context).emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.mail_outline_rounded, size: 20.r),
              validator: (value) => value == null || value.trim().isEmpty
                  ? S.of(context).pleaseEnterEmail
                  : null,
            ),
            SizedBox(height: AppSpacing.s4),
            AppTextField(
              controller: _passwordController,
              label: S.of(context).password,
              hint: S.of(context).passwordHint,
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
              validator: (v) => v == null || v.isEmpty
                  ? S.of(context).pleaseEnterPassword
                  : null,
            ),
            SizedBox(height: AppSpacing.s2),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: Text(
                  S.of(context).forgotPassword,
                  style: TextStyle(fontSize: 13.sp),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.s4),
            AppButton(
              label: S.of(context).signIn,
              fullWidth: true,
              loading: widget.isLoading,
              onPressed: _onSignIn,
            ),
            SizedBox(height: AppSpacing.s6),
            SocialLoginSection(
              onGooglePressed: () {
                context.read<SignInCubit>().signInWithGoogleMethod();
              },
              onApplePressed: () {
                context.read<SignInCubit>().signInWithAppleMethod();
              },
            ),
            SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }
}
