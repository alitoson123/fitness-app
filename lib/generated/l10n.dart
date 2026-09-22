// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appName => Intl.message('CoachHub', name: 'appName');
  String get splashSubtitle => Intl.message('Find Your Perfect Sports Coach', name: 'splashSubtitle');
  String get getStarted => Intl.message('Get Started', name: 'getStarted');
  String get chooseAccountType => Intl.message('Choose Account Type', name: 'chooseAccountType');
  String get chooseYourRole => Intl.message('Choose Your Role', name: 'chooseYourRole');
  String get howWillYouUse => Intl.message('How will you be using CoachHub?', name: 'howWillYouUse');
  String get iAmTrainee => Intl.message('I am a Trainee', name: 'iAmTrainee');
  String get traineeDesc => Intl.message('Find qualified coaches, book training sessions, and reach your goals.', name: 'traineeDesc');
  String get iAmCoach => Intl.message('I am a Coach', name: 'iAmCoach');
  String get coachDesc => Intl.message('Offer your sports training services, manage requests, and grow your clients.', name: 'coachDesc');
  String get continueButton => Intl.message('Continue', name: 'continueButton');
  String get signIn => Intl.message('Sign In', name: 'signIn');
  String get signUp => Intl.message('Sign Up', name: 'signUp');
  String get welcomeBack => Intl.message('Welcome Back', name: 'welcomeBack');
  String get signInSubtitle => Intl.message('Sign in to access your sports platform', name: 'signInSubtitle');
  String get email => Intl.message('Email', name: 'email');
  String get emailAddress => Intl.message('Email Address', name: 'emailAddress');
  String get emailHint => Intl.message('name@example.com', name: 'emailHint');
  String get password => Intl.message('Password', name: 'password');
  String get passwordHint => Intl.message('Enter your password', name: 'passwordHint');
  String get forgotPassword => Intl.message('Forgot Password?', name: 'forgotPassword');
  String get orContinueWith => Intl.message('or continue with', name: 'orContinueWith');
  String get google => Intl.message('Google', name: 'google');
  String get apple => Intl.message('Apple', name: 'apple');
  String get pleaseEnterEmail => Intl.message('Please enter your email', name: 'pleaseEnterEmail');
  String get pleaseEnterPassword => Intl.message('Please enter your password', name: 'pleaseEnterPassword');
  String get emailVerificationRequired => Intl.message('Email Verification Required', name: 'emailVerificationRequired');
  String get emailVerificationMessage => Intl.message('Please verify your email address to continue.', name: 'emailVerificationMessage');
  String get resendEmail => Intl.message('Resend Email', name: 'resendEmail');
  String get verificationEmailSent => Intl.message('Verification email sent successfully!', name: 'verificationEmailSent');
  String welcomeBackUser(Object name) => Intl.message('Welcome back, $name!', name: 'welcomeBackUser', args: [name]);
  String get createAccount => Intl.message('Create Account', name: 'createAccount');
  String get signUpSubtitle => Intl.message('Join CoachHub to get started today', name: 'signUpSubtitle');
  String get fullName => Intl.message('Full Name', name: 'fullName');
  String get fullNameHint => Intl.message('e.g. Ahmed Ali', name: 'fullNameHint');
  String get passwordLengthHint => Intl.message('At least 6 characters', name: 'passwordLengthHint');
  String get pleaseEnterName => Intl.message('Please enter your name', name: 'pleaseEnterName');
  String get passwordMinLength => Intl.message('Password must be at least 6 characters', name: 'passwordMinLength');
  String get accountCreated => Intl.message('Account Created', name: 'accountCreated');
  String get accountCreatedMessage => Intl.message('A verification link has been sent to your email. Please verify before signing in.', name: 'accountCreatedMessage');
  String get goToSignIn => Intl.message('Go to Sign In', name: 'goToSignIn');
  String get resetPassword => Intl.message('Reset Password', name: 'resetPassword');
  String get resetPasswordSubtitle => Intl.message('Enter your email address and we will send you a link to reset your password.', name: 'resetPasswordSubtitle');
  String get sendResetLink => Intl.message('Send Reset Link', name: 'sendResetLink');
  String get resetLinkSent => Intl.message('Reset Link Sent', name: 'resetLinkSent');
  String get resetLinkSentMessage => Intl.message('A password reset link has been sent to your email. Please check your inbox.', name: 'resetLinkSentMessage');
  String get backToSignIn => Intl.message('Back to Sign In', name: 'backToSignIn');
  String get ok => Intl.message('OK', name: 'ok');
  String get cancel => Intl.message('Cancel', name: 'cancel');
  String get success => Intl.message('Success', name: 'success');
  String get error => Intl.message('Error', name: 'error');
  String get warning => Intl.message('Warning', name: 'warning');
  String get resend => Intl.message('Resend', name: 'resend');
  String get traineeDiscovery => Intl.message('Trainee Discovery', name: 'traineeDiscovery');
  String get coachDashboard => Intl.message('Coach Dashboard', name: 'coachDashboard');
  String get traineeMarketplacePlaceholder => Intl.message('Trainee Marketplace Screen (Phase 3)', name: 'traineeMarketplacePlaceholder');
  String get coachDashboardPlaceholder => Intl.message('Coach Onboarding & Dashboard (Phase 3)', name: 'coachDashboardPlaceholder');
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
