import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/helpers/phone_number_helper.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:fitness_app/features/auth/phone_sign_in/data/repos/phone_auth_repo.dart';
import 'phone_auth_states.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final PhoneAuthRepo _phoneAuthRepo;

  SupportedCountry _selectedCountry = SupportedCountry.egypt;
  String _currentRawNumber = '';
  String _currentVerificationId = '';
  int? _resendToken;

  PhoneAuthCubit({required PhoneAuthRepo phoneAuthRepo})
      : _phoneAuthRepo = phoneAuthRepo,
        super(const PhoneAuthInitialState());

  SupportedCountry get selectedCountry => _selectedCountry;
  String get currentRawNumber => _currentRawNumber;
  String get currentVerificationId => _currentVerificationId;

  void selectCountry(SupportedCountry country) {
    _selectedCountry = country;
    emit(PhoneAuthInitialState(selectedCountry: country));
  }

  Future<void> sendOtp({required String rawNumber}) async {
    _currentRawNumber = rawNumber;
    final isValid = PhoneNumberHelper.isValidNumber(
      country: _selectedCountry,
      rawNumber: rawNumber,
    );

    if (!isValid) {
      emit(const PhoneAuthErrorState(
        errorMessage: 'Invalid phone number format for selected country.',
      ));
      return;
    }

    final fullNumber = PhoneNumberHelper.formatToE164(
      country: _selectedCountry,
      rawNumber: rawNumber,
    );

    emit(PhoneAuthCodeSendingState(
      selectedCountry: _selectedCountry,
      rawPhoneNumber: rawNumber,
    ));

    await _phoneAuthRepo.sendOtp(
      fullPhoneNumber: fullNumber,
      resendToken: _resendToken,
      verificationCompleted: (credential) async {
        LoggerService.info('Phone auto-verified', tag: 'PhoneAuthCubit');
        final result = await _phoneAuthRepo.handleAutoVerification(
          credential: credential,
          fullPhoneNumber: fullNumber,
          countryCode: _selectedCountry.countryCode,
        );
        result.fold(
          (failure) => emit(PhoneAuthErrorState(errorMessage: failure.errorMessage)),
          (data) => emit(PhoneAuthSuccessState(userModel: data.$1, targetRoute: data.$2)),
        );
      },
      verificationFailed: (e) {
        LoggerService.error('Verification failed: ${e.code}', tag: 'PhoneAuthCubit');
        emit(PhoneAuthErrorState(
          errorMessage: e.message ?? 'SMS dispatch failed. Please try again.',
        ));
      },
      codeSent: (verificationId, resendToken) {
        _currentVerificationId = verificationId;
        _resendToken = resendToken;
        final masked = PhoneNumberHelper.maskPhoneNumber(
          country: _selectedCountry,
          rawNumber: rawNumber,
        );
        emit(PhoneAuthCodeSentState(
          selectedCountry: _selectedCountry,
          rawPhoneNumber: rawNumber,
          verificationId: verificationId,
          resendToken: resendToken,
          maskedPhoneNumber: masked,
        ));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _currentVerificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp({required String smsCode}) async {
    if (smsCode.trim().length != 6) {
      emit(const PhoneAuthErrorState(errorMessage: 'Please enter a valid 6-digit code.'));
      return;
    }

    emit(const PhoneAuthVerifyingState());

    final fullNumber = PhoneNumberHelper.formatToE164(
      country: _selectedCountry,
      rawNumber: _currentRawNumber,
    );

    final result = await _phoneAuthRepo.verifyOtp(
      verificationId: _currentVerificationId,
      smsCode: smsCode.trim(),
      fullPhoneNumber: fullNumber,
      countryCode: _selectedCountry.countryCode,
    );

    result.fold(
      (failure) => emit(PhoneAuthErrorState(errorMessage: failure.errorMessage)),
      (data) => emit(PhoneAuthSuccessState(userModel: data.$1, targetRoute: data.$2)),
    );
  }

  Future<void> resendOtp() async {
    if (_currentRawNumber.isNotEmpty) {
      await sendOtp(rawNumber: _currentRawNumber);
    }
  }

  void resetToInitial() {
    emit(PhoneAuthInitialState(selectedCountry: _selectedCountry));
  }
}
