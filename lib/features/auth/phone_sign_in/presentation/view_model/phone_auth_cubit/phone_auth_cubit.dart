import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/errors/auth_error_messages.dart';
import 'package:fitness_app/core/helpers/phone_number_helper.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:fitness_app/features/auth/phone_sign_in/data/repos/phone_auth_repo.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'phone_auth_states.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final PhoneAuthRepo _phoneAuthRepo;

  SupportedCountry _selectedCountry = SupportedCountry.egypt;
  String _currentRawNumber = '';
  String _currentVerificationId = '';
  int? _resendToken;

  /// True while a sign-in (typed code or Android auto-verify) is running or
  /// has succeeded, so a late auto-verify callback can't sign in twice.
  bool _signInStarted = false;

  PhoneAuthCubit({required PhoneAuthRepo phoneAuthRepo})
      : _phoneAuthRepo = phoneAuthRepo,
        super(const PhoneAuthInitialState());

  SupportedCountry get selectedCountry => _selectedCountry;
  String get currentRawNumber => _currentRawNumber;
  String get currentVerificationId => _currentVerificationId;

  /// Firebase callbacks can fire after the screen (and this cubit) is gone.
  void _emitSafe(PhoneAuthState state) {
    if (!isClosed) emit(state);
  }

  void selectCountry(SupportedCountry country) {
    _selectedCountry = country;
    _emitSafe(PhoneAuthInitialState(selectedCountry: country));
  }

  Future<void> sendOtp({required String rawNumber}) async {
    _currentRawNumber = rawNumber;
    final isValid = PhoneNumberHelper.isValidNumber(
      country: _selectedCountry,
      rawNumber: rawNumber,
    );

    if (!isValid) {
      _emitSafe(PhoneAuthErrorState(errorMessage: S.current.invalidPhoneFormat));
      return;
    }

    final fullNumber = PhoneNumberHelper.formatToE164(
      country: _selectedCountry,
      rawNumber: rawNumber,
    );

    _emitSafe(PhoneAuthCodeSendingState(
      selectedCountry: _selectedCountry,
      rawPhoneNumber: rawNumber,
    ));

    await _phoneAuthRepo.sendOtp(
      fullPhoneNumber: fullNumber,
      resendToken: _resendToken,
      verificationCompleted: (credential) async {
        if (isClosed || _signInStarted) return;
        _signInStarted = true;
        LoggerService.info('Phone auto-verified', tag: 'PhoneAuthCubit');
        _emitSafe(const PhoneAuthVerifyingState());
        final result = await _phoneAuthRepo.handleAutoVerification(
          credential: credential,
          fullPhoneNumber: fullNumber,
          countryCode: _selectedCountry.countryCode,
        );
        result.fold(
          (failure) {
            _signInStarted = false;
            _emitSafe(PhoneAuthErrorState(errorMessage: failure.errorMessage));
          },
          (data) => _emitSafe(
            PhoneAuthSuccessState(userModel: data.$1, targetRoute: data.$2),
          ),
        );
      },
      verificationFailed: (e) {
        LoggerService.error('Verification failed: ${e.code}', tag: 'PhoneAuthCubit');
        const specificCodes = {
          'invalid-phone-number',
          'too-many-requests',
          'quota-exceeded',
          'network-request-failed',
        };
        _emitSafe(PhoneAuthErrorState(
          errorMessage: specificCodes.contains(e.code)
              ? AuthErrorMessages.fromAuthException(e)
              : S.current.smsSendFailed,
        ));
      },
      codeSent: (verificationId, resendToken) {
        _currentVerificationId = verificationId;
        _resendToken = resendToken;
        final masked = PhoneNumberHelper.maskPhoneNumber(
          country: _selectedCountry,
          rawNumber: rawNumber,
        );
        _emitSafe(PhoneAuthCodeSentState(
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
      _emitSafe(PhoneAuthErrorState(errorMessage: S.current.invalidOtpCode));
      return;
    }
    if (_signInStarted) return;
    _signInStarted = true;

    _emitSafe(const PhoneAuthVerifyingState());

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
      (failure) {
        _signInStarted = false;
        _emitSafe(PhoneAuthErrorState(errorMessage: failure.errorMessage));
      },
      (data) => _emitSafe(
        PhoneAuthSuccessState(userModel: data.$1, targetRoute: data.$2),
      ),
    );
  }

  Future<void> resendOtp() async {
    if (_currentRawNumber.isNotEmpty) {
      await sendOtp(rawNumber: _currentRawNumber);
    }
  }

  void resetToInitial() {
    _emitSafe(PhoneAuthInitialState(selectedCountry: _selectedCountry));
  }
}
