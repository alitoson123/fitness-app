import 'package:fitness_app/core/helpers/phone_number_helper.dart';
import 'package:fitness_app/features/auth/core/data/models/user_model.dart';

abstract class PhoneAuthState {
  const PhoneAuthState();
}

class PhoneAuthInitialState extends PhoneAuthState {
  final SupportedCountry selectedCountry;

  const PhoneAuthInitialState({
    this.selectedCountry = SupportedCountry.egypt,
  });
}

class PhoneAuthCodeSendingState extends PhoneAuthState {
  final SupportedCountry selectedCountry;
  final String rawPhoneNumber;

  const PhoneAuthCodeSendingState({
    required this.selectedCountry,
    required this.rawPhoneNumber,
  });
}

class PhoneAuthCodeSentState extends PhoneAuthState {
  final SupportedCountry selectedCountry;
  final String rawPhoneNumber;
  final String verificationId;
  final int? resendToken;
  final String maskedPhoneNumber;

  const PhoneAuthCodeSentState({
    required this.selectedCountry,
    required this.rawPhoneNumber,
    required this.verificationId,
    this.resendToken,
    required this.maskedPhoneNumber,
  });
}

class PhoneAuthVerifyingState extends PhoneAuthState {
  const PhoneAuthVerifyingState();
}

class PhoneAuthSuccessState extends PhoneAuthState {
  final UserModel userModel;
  final String targetRoute;

  const PhoneAuthSuccessState({
    required this.userModel,
    required this.targetRoute,
  });
}

class PhoneAuthErrorState extends PhoneAuthState {
  final String errorMessage;

  const PhoneAuthErrorState({required this.errorMessage});
}
