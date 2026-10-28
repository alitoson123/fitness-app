import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/helpers/phone_number_helper.dart';
import 'package:fitness_app/core/navigator/app_routes.dart';
import 'package:fitness_app/features/auth/core/data/models/user_model.dart';
import 'package:fitness_app/features/auth/phone_sign_in/data/repos/phone_auth_repo.dart';
import 'package:fitness_app/features/auth/phone_sign_in/presentation/view_model/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:fitness_app/features/auth/phone_sign_in/presentation/view_model/phone_auth_cubit/phone_auth_states.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePhoneAuthRepo implements PhoneAuthRepo {
  bool sendOtpCalled = false;
  String? sentPhoneNumber;
  bool verifyOtpSuccess = true;

  @override
  Future<void> sendOtp({
    required String fullPhoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? resendToken,
  }) async {
    sendOtpCalled = true;
    sentPhoneNumber = fullPhoneNumber;
    codeSent('mock-verification-id', 12345);
  }

  @override
  Future<Either<Failure, (UserModel, String)>> verifyOtp({
    required String verificationId,
    required String smsCode,
    required String fullPhoneNumber,
    required String countryCode,
  }) async {
    if (verifyOtpSuccess) {
      final user = UserModel(
        uid: 'mock-uid-123',
        phoneNumber: fullPhoneNumber,
        countryCode: countryCode,
        role: 'trainee',
      );
      return Right((user, AppRoutes.traineeHome));
    } else {
      return Left(ServerFailure(errorMessage: 'Invalid OTP code.'));
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakePhoneAuthRepo fakeRepo;
  late PhoneAuthCubit cubit;

  setUp(() {
    fakeRepo = FakePhoneAuthRepo();
    cubit = PhoneAuthCubit(phoneAuthRepo: fakeRepo);
  });

  tearDown(() {
    cubit.close();
  });

  test('Initial state is PhoneAuthInitialState with default Egypt (+20)', () {
    expect(cubit.state, isA<PhoneAuthInitialState>());
    expect(cubit.selectedCountry, SupportedCountry.egypt);
  });

  test('selectCountry updates selected country and emits PhoneAuthInitialState', () {
    cubit.selectCountry(SupportedCountry.lebanon);
    expect(cubit.selectedCountry, SupportedCountry.lebanon);
    expect(cubit.state, isA<PhoneAuthInitialState>());
  });

  test('sendOtp with invalid phone number emits PhoneAuthErrorState', () async {
    await cubit.sendOtp(rawNumber: '1234');
    expect(cubit.state, isA<PhoneAuthErrorState>());
    expect(fakeRepo.sendOtpCalled, isFalse);
  });

  test('sendOtp with valid Egypt number calls repo and emits CodeSentState', () async {
    await cubit.sendOtp(rawNumber: '1012345678');
    expect(fakeRepo.sendOtpCalled, isTrue);
    expect(fakeRepo.sentPhoneNumber, '+201012345678');
    expect(cubit.state, isA<PhoneAuthCodeSentState>());
  });

  test('verifyOtp with invalid length emits PhoneAuthErrorState', () async {
    await cubit.verifyOtp(smsCode: '123');
    expect(cubit.state, isA<PhoneAuthErrorState>());
  });

  test('verifyOtp with valid code emits PhoneAuthSuccessState on success', () async {
    await cubit.sendOtp(rawNumber: '1012345678');
    fakeRepo.verifyOtpSuccess = true;

    await cubit.verifyOtp(smsCode: '123456');
    expect(cubit.state, isA<PhoneAuthSuccessState>());
    final state = cubit.state as PhoneAuthSuccessState;
    expect(state.userModel.uid, 'mock-uid-123');
    expect(state.targetRoute, AppRoutes.traineeHome);
  });

  test('verifyOtp emits PhoneAuthErrorState when repo returns Failure', () async {
    await cubit.sendOtp(rawNumber: '1012345678');
    fakeRepo.verifyOtpSuccess = false;

    await cubit.verifyOtp(smsCode: '000000');
    expect(cubit.state, isA<PhoneAuthErrorState>());
    final state = cubit.state as PhoneAuthErrorState;
    expect(state.errorMessage, 'Invalid OTP code.');
  });
}
