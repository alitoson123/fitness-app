import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/helpers/message.dart';
import 'package:fitness_app/core/navigator/app_routes.dart';
import 'package:fitness_app/generated/l10n.dart';
import '../view_model/phone_auth_cubit/phone_auth_cubit.dart';
import '../view_model/phone_auth_cubit/phone_auth_states.dart';
import '../widgets/country_code_dropdown.dart';
import '../widgets/phone_number_text_field.dart';
import '../widgets/phone_sign_in_header.dart';
import '../widgets/send_otp_button.dart';

class PhoneSignInView extends StatefulWidget {
  const PhoneSignInView({super.key});

  @override
  State<PhoneSignInView> createState() => _PhoneSignInViewState();
}

class _PhoneSignInViewState extends State<PhoneSignInView> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    final rawNumber = _phoneController.text.trim();
    if (rawNumber.isEmpty) {
      Message.showError(context, S.of(context).invalidPhoneFormat);
      return;
    }
    context.read<PhoneAuthCubit>().sendOtp(rawNumber: rawNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
          listener: (context, state) {
            if (state is PhoneAuthCodeSentState) {
              Message.showSuccess(context, S.of(context).codeSentSuccess);
              context.push(AppRoutes.otpVerification, extra: context.read<PhoneAuthCubit>());
            } else if (state is PhoneAuthSuccessState) {
              context.go(state.targetRoute);
            } else if (state is PhoneAuthErrorState) {
              Message.showError(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            final cubit = context.read<PhoneAuthCubit>();
            final isLoading = state is PhoneAuthCodeSendingState;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  const PhoneSignInHeader(),
                  SizedBox(height: 36.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CountryCodeDropdown(
                        selectedCountry: cubit.selectedCountry,
                        onCountryChanged: cubit.selectCountry,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: PhoneNumberTextField(
                          controller: _phoneController,
                          selectedCountry: cubit.selectedCountry,
                          onSubmitted: (_) => _onSendOtp(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  SendOtpButton(
                    isLoading: isLoading,
                    onPressed: _onSendOtp,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
