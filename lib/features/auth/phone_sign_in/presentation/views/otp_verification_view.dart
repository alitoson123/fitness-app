import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/helpers/message.dart';
import 'package:fitness_app/core/helpers/phone_number_helper.dart';
import 'package:fitness_app/generated/l10n.dart';
import '../view_model/phone_auth_cubit/phone_auth_cubit.dart';
import '../view_model/phone_auth_cubit/phone_auth_states.dart';
import '../widgets/otp_pin_input.dart';
import '../widgets/otp_timer_resend.dart';
import '../widgets/otp_verification_header.dart';
import '../widgets/verify_otp_button.dart';

class OtpVerificationView extends StatefulWidget {
  final PhoneAuthCubit cubit;

  const OtpVerificationView({super.key, required this.cubit});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onVerify() {
    final code = _pinController.text.trim();
    if (code.length != 6) {
      Message.showError(context, S.of(context).invalidOtpCode);
      return;
    }
    widget.cubit.verifyOtp(smsCode: code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
            listener: (context, state) {
              if (state is PhoneAuthSuccessState) {
                context.go(state.targetRoute);
              } else if (state is PhoneAuthErrorState) {
                Message.showError(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              final maskedNumber = PhoneNumberHelper.maskPhoneNumber(
                country: widget.cubit.selectedCountry,
                rawNumber: widget.cubit.currentRawNumber,
              );
              final isVerifying = state is PhoneAuthVerifyingState;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OtpVerificationHeader(
                      maskedPhoneNumber: maskedNumber,
                      onEditNumber: () => context.pop(),
                    ),
                    SizedBox(height: 36.h),
                    OtpPinInput(
                      controller: _pinController,
                      onCompleted: (_) => _onVerify(),
                    ),
                    SizedBox(height: 24.h),
                    OtpTimerResend(
                      onResend: () => widget.cubit.resendOtp(),
                    ),
                    SizedBox(height: 32.h),
                    VerifyOtpButton(
                      isLoading: isVerifying,
                      onPressed: _onVerify,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
