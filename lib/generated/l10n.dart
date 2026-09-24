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

  /// `CoachHub`
  String get appName {
    return Intl.message(
      'CoachHub',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Perfect Sports Coach`
  String get splashSubtitle {
    return Intl.message(
      'Find Your Perfect Sports Coach',
      name: 'splashSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Choose Account Type`
  String get chooseAccountType {
    return Intl.message(
      'Choose Account Type',
      name: 'chooseAccountType',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Role`
  String get chooseYourRole {
    return Intl.message(
      'Choose Your Role',
      name: 'chooseYourRole',
      desc: '',
      args: [],
    );
  }

  /// `How will you be using CoachHub?`
  String get howWillYouUse {
    return Intl.message(
      'How will you be using CoachHub?',
      name: 'howWillYouUse',
      desc: '',
      args: [],
    );
  }

  /// `I am a Trainee`
  String get iAmTrainee {
    return Intl.message(
      'I am a Trainee',
      name: 'iAmTrainee',
      desc: '',
      args: [],
    );
  }

  /// `Find qualified coaches, book training sessions, and reach your goals.`
  String get traineeDesc {
    return Intl.message(
      'Find qualified coaches, book training sessions, and reach your goals.',
      name: 'traineeDesc',
      desc: '',
      args: [],
    );
  }

  /// `I am a Coach`
  String get iAmCoach {
    return Intl.message(
      'I am a Coach',
      name: 'iAmCoach',
      desc: '',
      args: [],
    );
  }

  /// `Offer your sports training services, manage requests, and grow your clients.`
  String get coachDesc {
    return Intl.message(
      'Offer your sports training services, manage requests, and grow your clients.',
      name: 'coachDesc',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to access your sports platform`
  String get signInSubtitle {
    return Intl.message(
      'Sign in to access your sports platform',
      name: 'signInSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `name@example.com`
  String get emailHint {
    return Intl.message(
      'name@example.com',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `or continue with`
  String get orContinueWith {
    return Intl.message(
      'or continue with',
      name: 'orContinueWith',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message(
      'Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Apple`
  String get apple {
    return Intl.message(
      'Apple',
      name: 'apple',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email Verification Required`
  String get emailVerificationRequired {
    return Intl.message(
      'Email Verification Required',
      name: 'emailVerificationRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your email address to continue.`
  String get emailVerificationMessage {
    return Intl.message(
      'Please verify your email address to continue.',
      name: 'emailVerificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Resend Email`
  String get resendEmail {
    return Intl.message(
      'Resend Email',
      name: 'resendEmail',
      desc: '',
      args: [],
    );
  }

  /// `Verification email sent successfully!`
  String get verificationEmailSent {
    return Intl.message(
      'Verification email sent successfully!',
      name: 'verificationEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back, {name}!`
  String welcomeBackUser(Object name) {
    return Intl.message(
      'Welcome back, $name!',
      name: 'welcomeBackUser',
      desc: '',
      args: [name],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Join CoachHub to get started today`
  String get signUpSubtitle {
    return Intl.message(
      'Join CoachHub to get started today',
      name: 'signUpSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Ahmed Ali`
  String get fullNameHint {
    return Intl.message(
      'e.g. Ahmed Ali',
      name: 'fullNameHint',
      desc: '',
      args: [],
    );
  }

  /// `At least 6 characters`
  String get passwordLengthHint {
    return Intl.message(
      'At least 6 characters',
      name: 'passwordLengthHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter your name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Account Created`
  String get accountCreated {
    return Intl.message(
      'Account Created',
      name: 'accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `A verification link has been sent to your email. Please verify before signing in.`
  String get accountCreatedMessage {
    return Intl.message(
      'A verification link has been sent to your email. Please verify before signing in.',
      name: 'accountCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Go to Sign In`
  String get goToSignIn {
    return Intl.message(
      'Go to Sign In',
      name: 'goToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we will send you a link to reset your password.`
  String get resetPasswordSubtitle {
    return Intl.message(
      'Enter your email address and we will send you a link to reset your password.',
      name: 'resetPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Reset Link Sent`
  String get resetLinkSent {
    return Intl.message(
      'Reset Link Sent',
      name: 'resetLinkSent',
      desc: '',
      args: [],
    );
  }

  /// `A password reset link has been sent to your email. Please check your inbox.`
  String get resetLinkSentMessage {
    return Intl.message(
      'A password reset link has been sent to your email. Please check your inbox.',
      name: 'resetLinkSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Back to Sign In`
  String get backToSignIn {
    return Intl.message(
      'Back to Sign In',
      name: 'backToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Trainee Discovery`
  String get traineeDiscovery {
    return Intl.message(
      'Trainee Discovery',
      name: 'traineeDiscovery',
      desc: '',
      args: [],
    );
  }

  /// `Coach Dashboard`
  String get coachDashboard {
    return Intl.message(
      'Coach Dashboard',
      name: 'coachDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Trainee Marketplace Screen (Phase 3)`
  String get traineeMarketplacePlaceholder {
    return Intl.message(
      'Trainee Marketplace Screen (Phase 3)',
      name: 'traineeMarketplacePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Coach Onboarding & Dashboard (Phase 3)`
  String get coachDashboardPlaceholder {
    return Intl.message(
      'Coach Onboarding & Dashboard (Phase 3)',
      name: 'coachDashboardPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Expert Coach`
  String get onboardingTitle1 {
    return Intl.message(
      'Find Your Expert Coach',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Connect with certified personal trainers specialized in Gym, Boxing, Swimming, Tennis, and more.`
  String get onboardingDesc1 {
    return Intl.message(
      'Connect with certified personal trainers specialized in Gym, Boxing, Swimming, Tennis, and more.',
      name: 'onboardingDesc1',
      desc: '',
      args: [],
    );
  }

  /// `Certified Coaches`
  String get onboardingBadge1 {
    return Intl.message(
      'Certified Coaches',
      name: 'onboardingBadge1',
      desc: '',
      args: [],
    );
  }

  /// `Personalized Plans & Booking`
  String get onboardingTitle2 {
    return Intl.message(
      'Personalized Plans & Booking',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Schedule private sessions and follow custom workout and nutrition plans that match your lifestyle.`
  String get onboardingDesc2 {
    return Intl.message(
      'Schedule private sessions and follow custom workout and nutrition plans that match your lifestyle.',
      name: 'onboardingDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Flexible Schedules`
  String get onboardingBadge2 {
    return Intl.message(
      'Flexible Schedules',
      name: 'onboardingBadge2',
      desc: '',
      args: [],
    );
  }

  /// `Track Progress & Reach Goals`
  String get onboardingTitle3 {
    return Intl.message(
      'Track Progress & Reach Goals',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Monitor your performance stats, workout streaks, and celebrate milestones with coach guidance.`
  String get onboardingDesc3 {
    return Intl.message(
      'Monitor your performance stats, workout streaks, and celebrate milestones with coach guidance.',
      name: 'onboardingDesc3',
      desc: '',
      args: [],
    );
  }

  /// `Real-Time Tracking`
  String get onboardingBadge3 {
    return Intl.message(
      'Real-Time Tracking',
      name: 'onboardingBadge3',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStartedNow {
    return Intl.message(
      'Get Started',
      name: 'getStartedNow',
      desc: '',
      args: [],
    );
  }

  /// `STEP {current} OF {total}`
  String stepOf(Object current, Object total) {
    return Intl.message(
      'STEP $current OF $total',
      name: 'stepOf',
      desc: '',
      args: [current, total],
    );
  }

  /// `Complete Your Profile`
  String get completeYourProfile {
    return Intl.message(
      'Complete Your Profile',
      name: 'completeYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Trainee Setup`
  String get traineeSetup {
    return Intl.message(
      'Trainee Setup',
      name: 'traineeSetup',
      desc: '',
      args: [],
    );
  }

  /// `Your Profile`
  String get yourProfile {
    return Intl.message(
      'Your Profile',
      name: 'yourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo so coaches know who you are`
  String get addPhotoPrompt {
    return Intl.message(
      'Add a photo so coaches know who you are',
      name: 'addPhotoPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Tap to upload photo`
  String get tapToUploadPhoto {
    return Intl.message(
      'Tap to upload photo',
      name: 'tapToUploadPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Prefer not to say`
  String get preferNotToSay {
    return Intl.message(
      'Prefer not to say',
      name: 'preferNotToSay',
      desc: '',
      args: [],
    );
  }

  /// `Your city or region (optional)`
  String get cityOrRegionOptional {
    return Intl.message(
      'Your city or region (optional)',
      name: 'cityOrRegionOptional',
      desc: '',
      args: [],
    );
  }

  /// `Skip for now`
  String get skipForNow {
    return Intl.message(
      'Skip for now',
      name: 'skipForNow',
      desc: '',
      args: [],
    );
  }

  /// `Your Sports`
  String get yourSports {
    return Intl.message(
      'Your Sports',
      name: 'yourSports',
      desc: '',
      args: [],
    );
  }

  /// `Select one or more sports you want to train in`
  String get selectSportsSubtitle {
    return Intl.message(
      'Select one or more sports you want to train in',
      name: 'selectSportsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 sport selected} other{{count} sports selected}}`
  String sportsSelected(num count) {
    return Intl.plural(
      count,
      one: '1 sport selected',
      other: '$count sports selected',
      name: 'sportsSelected',
      desc: '',
      args: [count],
    );
  }

  /// `Your Level`
  String get yourLevel {
    return Intl.message(
      'Your Level',
      name: 'yourLevel',
      desc: '',
      args: [],
    );
  }

  /// `This helps us match you with the right coaches`
  String get levelSubtitle {
    return Intl.message(
      'This helps us match you with the right coaches',
      name: 'levelSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Beginner',
      name: 'beginner',
      desc: '',
      args: [],
    );
  }

  /// `Just starting out`
  String get beginnerDesc {
    return Intl.message(
      'Just starting out',
      name: 'beginnerDesc',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get intermediate {
    return Intl.message(
      'Intermediate',
      name: 'intermediate',
      desc: '',
      args: [],
    );
  }

  /// `Some experience`
  String get intermediateDesc {
    return Intl.message(
      'Some experience',
      name: 'intermediateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `Experienced and want to level up`
  String get advancedDesc {
    return Intl.message(
      'Experienced and want to level up',
      name: 'advancedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Your Goal`
  String get yourGoal {
    return Intl.message(
      'Your Goal',
      name: 'yourGoal',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to achieve?`
  String get goalSubtitle {
    return Intl.message(
      'What do you want to achieve?',
      name: 'goalSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `General Fitness`
  String get generalFitness {
    return Intl.message(
      'General Fitness',
      name: 'generalFitness',
      desc: '',
      args: [],
    );
  }

  /// `Weight Loss`
  String get weightLoss {
    return Intl.message(
      'Weight Loss',
      name: 'weightLoss',
      desc: '',
      args: [],
    );
  }

  /// `Competition Prep`
  String get competitionPrep {
    return Intl.message(
      'Competition Prep',
      name: 'competitionPrep',
      desc: '',
      args: [],
    );
  }

  /// `Skill Development`
  String get skillDevelopment {
    return Intl.message(
      'Skill Development',
      name: 'skillDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Fun & Recreation`
  String get funRecreation {
    return Intl.message(
      'Fun & Recreation',
      name: 'funRecreation',
      desc: '',
      args: [],
    );
  }

  /// `Complete Profile`
  String get completeProfile {
    return Intl.message(
      'Complete Profile',
      name: 'completeProfile',
      desc: '',
      args: [],
    );
  }

  /// `You're all set!`
  String get allSetTitle {
    return Intl.message(
      'You\'re all set!',
      name: 'allSetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your trainee profile is ready. Start discovering coaches who match your sport and goals.`
  String get allSetSubtitle {
    return Intl.message(
      'Your trainee profile is ready. Start discovering coaches who match your sport and goals.',
      name: 'allSetSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Start Exploring Coaches`
  String get startExploringCoaches {
    return Intl.message(
      'Start Exploring Coaches',
      name: 'startExploringCoaches',
      desc: '',
      args: [],
    );
  }

  /// `(Demo ends here — Home screen is Phase 2)`
  String get demoEndsHere {
    return Intl.message(
      '(Demo ends here — Home screen is Phase 2)',
      name: 'demoEndsHere',
      desc: '',
      args: [],
    );
  }

  /// `Football`
  String get sportFootball {
    return Intl.message(
      'Football',
      name: 'sportFootball',
      desc: '',
      args: [],
    );
  }

  /// `Basketball`
  String get sportBasketball {
    return Intl.message(
      'Basketball',
      name: 'sportBasketball',
      desc: '',
      args: [],
    );
  }

  /// `Swimming`
  String get sportSwimming {
    return Intl.message(
      'Swimming',
      name: 'sportSwimming',
      desc: '',
      args: [],
    );
  }

  /// `Tennis`
  String get sportTennis {
    return Intl.message(
      'Tennis',
      name: 'sportTennis',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get sportRunning {
    return Intl.message(
      'Running',
      name: 'sportRunning',
      desc: '',
      args: [],
    );
  }

  /// `Boxing`
  String get sportBoxing {
    return Intl.message(
      'Boxing',
      name: 'sportBoxing',
      desc: '',
      args: [],
    );
  }

  /// `Gym`
  String get sportGym {
    return Intl.message(
      'Gym',
      name: 'sportGym',
      desc: '',
      args: [],
    );
  }

  /// `Cycling`
  String get sportCycling {
    return Intl.message(
      'Cycling',
      name: 'sportCycling',
      desc: '',
      args: [],
    );
  }

  /// `Yoga`
  String get sportYoga {
    return Intl.message(
      'Yoga',
      name: 'sportYoga',
      desc: '',
      args: [],
    );
  }

  /// `Martial Arts`
  String get sportMartialArts {
    return Intl.message(
      'Martial Arts',
      name: 'sportMartialArts',
      desc: '',
      args: [],
    );
  }

  /// `Volleyball`
  String get sportVolleyball {
    return Intl.message(
      'Volleyball',
      name: 'sportVolleyball',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get sportOther {
    return Intl.message(
      'Other',
      name: 'sportOther',
      desc: '',
      args: [],
    );
  }
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
