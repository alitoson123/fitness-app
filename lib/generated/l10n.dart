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

  /// `Create your trainee profile and start your fitness journey`
  String get traineeSetupSubtitle {
    return Intl.message(
      'Create your trainee profile and start your fitness journey',
      name: 'traineeSetupSubtitle',
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

  /// `Coach Application`
  String get coachSetupTitle {
    return Intl.message(
      'Coach Application',
      name: 'coachSetupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create your professional coach profile and submit verification`
  String get coachSetupSubtitle {
    return Intl.message(
      'Create your professional coach profile and submit verification',
      name: 'coachSetupSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get stepPersonalInfo {
    return Intl.message(
      'Personal Info',
      name: 'stepPersonalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Professional Info`
  String get stepProfessionalInfo {
    return Intl.message(
      'Professional Info',
      name: 'stepProfessionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Pricing & Schedule`
  String get stepPricingAvailability {
    return Intl.message(
      'Pricing & Schedule',
      name: 'stepPricingAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get stepVerificationDocs {
    return Intl.message(
      'Verification',
      name: 'stepVerificationDocs',
      desc: '',
      args: [],
    );
  }

  /// `Review & Submit`
  String get stepReviewSubmit {
    return Intl.message(
      'Review & Submit',
      name: 'stepReviewSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo is required`
  String get coachPhotoRequired {
    return Intl.message(
      'Profile photo is required',
      name: 'coachPhotoRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `+966 50 123 4567`
  String get phoneHint {
    return Intl.message(
      '+966 50 123 4567',
      name: 'phoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Professional Bio`
  String get bio {
    return Intl.message(
      'Professional Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Tell trainees about your coaching philosophy, background, and experience (min 30 characters)...`
  String get bioHint {
    return Intl.message(
      'Tell trainees about your coaching philosophy, background, and experience (min 30 characters)...',
      name: 'bioHint',
      desc: '',
      args: [],
    );
  }

  /// `Bio must be at least 30 characters`
  String get bioMinLength {
    return Intl.message(
      'Bio must be at least 30 characters',
      name: 'bioMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Saudi Arabia, Egypt`
  String get countryHint {
    return Intl.message(
      'e.g. Saudi Arabia, Egypt',
      name: 'countryHint',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get selectCountry {
    return Intl.message(
      'Select Country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Riyadh, Cairo`
  String get cityHint {
    return Intl.message(
      'e.g. Riyadh, Cairo',
      name: 'cityHint',
      desc: '',
      args: [],
    );
  }

  /// `Select City`
  String get selectCity {
    return Intl.message(
      'Select City',
      name: 'selectCity',
      desc: '',
      args: [],
    );
  }

  /// `Please select a country first`
  String get selectCountryFirst {
    return Intl.message(
      'Please select a country first',
      name: 'selectCountryFirst',
      desc: '',
      args: [],
    );
  }

  /// `Languages Spoken`
  String get languages {
    return Intl.message(
      'Languages Spoken',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `Select Languages`
  String get selectLanguages {
    return Intl.message(
      'Select Languages',
      name: 'selectLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one language`
  String get pleaseSelectLanguage {
    return Intl.message(
      'Please select at least one language',
      name: 'pleaseSelectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Sports & Specialties`
  String get sportsAndSpecialties {
    return Intl.message(
      'Sports & Specialties',
      name: 'sportsAndSpecialties',
      desc: '',
      args: [],
    );
  }

  /// `Select the sports you coach`
  String get selectSportsYouCoach {
    return Intl.message(
      'Select the sports you coach',
      name: 'selectSportsYouCoach',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one sport`
  String get pleaseSelectSport {
    return Intl.message(
      'Please select at least one sport',
      name: 'pleaseSelectSport',
      desc: '',
      args: [],
    );
  }

  /// `Specialties & Focus Areas`
  String get specialties1 {
    return Intl.message(
      'Specialties & Focus Areas',
      name: 'specialties1',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Strength, Weight Loss, Technique`
  String get specialtiesHint {
    return Intl.message(
      'e.g. Strength, Weight Loss, Technique',
      name: 'specialtiesHint',
      desc: '',
      args: [],
    );
  }

  /// `Years of Coaching Experience`
  String get yearsOfExperience {
    return Intl.message(
      'Years of Coaching Experience',
      name: 'yearsOfExperience',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Training Rate`
  String get pricingTitle {
    return Intl.message(
      'Hourly Training Rate',
      name: 'pricingTitle',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 150`
  String get hourlyRateHint {
    return Intl.message(
      'e.g. 150',
      name: 'hourlyRateHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid hourly rate greater than 0`
  String get hourlyRateRequired {
    return Intl.message(
      'Please enter a valid hourly rate greater than 0',
      name: 'hourlyRateRequired',
      desc: '',
      args: [],
    );
  }

  /// `SAR / hr`
  String get currencySAR {
    return Intl.message(
      'SAR / hr',
      name: 'currencySAR',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Availability Overview`
  String get availabilityTitle {
    return Intl.message(
      'Weekly Availability Overview',
      name: 'availabilityTitle',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Sun-Thu 5:00 PM - 10:00 PM, Sat 9:00 AM - 2:00 PM`
  String get availabilityHint {
    return Intl.message(
      'e.g. Sun-Thu 5:00 PM - 10:00 PM, Sat 9:00 AM - 2:00 PM',
      name: 'availabilityHint',
      desc: '',
      args: [],
    );
  }

  /// `Please provide your general availability schedule`
  String get availabilityRequired {
    return Intl.message(
      'Please provide your general availability schedule',
      name: 'availabilityRequired',
      desc: '',
      args: [],
    );
  }

  /// `Upload Verification Documents`
  String get verificationDocsTitle {
    return Intl.message(
      'Upload Verification Documents',
      name: 'verificationDocsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Government ID and at least one coaching certificate are mandatory for verification.`
  String get verificationDocsSubtitle {
    return Intl.message(
      'Government ID and at least one coaching certificate are mandatory for verification.',
      name: 'verificationDocsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Government ID or Passport`
  String get nationalIdOrPassport {
    return Intl.message(
      'Government ID or Passport',
      name: 'nationalIdOrPassport',
      desc: '',
      args: [],
    );
  }

  /// `Upload photo or PDF of your National ID or Passport`
  String get nationalIdHint {
    return Intl.message(
      'Upload photo or PDF of your National ID or Passport',
      name: 'nationalIdHint',
      desc: '',
      args: [],
    );
  }

  /// `Coaching Certificate or Degree`
  String get coachingCertificates {
    return Intl.message(
      'Coaching Certificate or Degree',
      name: 'coachingCertificates',
      desc: '',
      args: [],
    );
  }

  /// `Upload coaching certification, diploma, or sports degree`
  String get coachingCertificatesHint {
    return Intl.message(
      'Upload coaching certification, diploma, or sports degree',
      name: 'coachingCertificatesHint',
      desc: '',
      args: [],
    );
  }

  /// `Upload Document`
  String get uploadDocument {
    return Intl.message(
      'Upload Document',
      name: 'uploadDocument',
      desc: '',
      args: [],
    );
  }

  /// `Document Selected`
  String get fileUploaded {
    return Intl.message(
      'Document Selected',
      name: 'fileUploaded',
      desc: '',
      args: [],
    );
  }

  /// `File size exceeds 10MB limit`
  String get fileTooLarge {
    return Intl.message(
      'File size exceeds 10MB limit',
      name: 'fileTooLarge',
      desc: '',
      args: [],
    );
  }

  /// `Please upload your government ID`
  String get idRequired {
    return Intl.message(
      'Please upload your government ID',
      name: 'idRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please upload at least one coaching certificate or degree`
  String get certRequired {
    return Intl.message(
      'Please upload at least one coaching certificate or degree',
      name: 'certRequired',
      desc: '',
      args: [],
    );
  }

  /// `Review Your Application`
  String get reviewTitle {
    return Intl.message(
      'Review Your Application',
      name: 'reviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please verify all details before submitting for moderation.`
  String get reviewSubtitle {
    return Intl.message(
      'Please verify all details before submitting for moderation.',
      name: 'reviewSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Submit Application`
  String get submitApplication {
    return Intl.message(
      'Submit Application',
      name: 'submitApplication',
      desc: '',
      args: [],
    );
  }

  /// `Submitting application...`
  String get submittingApplication {
    return Intl.message(
      'Submitting application...',
      name: 'submittingApplication',
      desc: '',
      args: [],
    );
  }

  /// `Application Submitted!`
  String get applicationSubmitted {
    return Intl.message(
      'Application Submitted!',
      name: 'applicationSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Your application has been received and is currently under review by our administration team.`
  String get applicationSubmittedDesc {
    return Intl.message(
      'Your application has been received and is currently under review by our administration team.',
      name: 'applicationSubmittedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Verification in Progress`
  String get verificationPendingTitle {
    return Intl.message(
      'Verification in Progress',
      name: 'verificationPendingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our moderation team is reviewing your profile and credentials.`
  String get verificationPendingSubtitle {
    return Intl.message(
      'Our moderation team is reviewing your profile and credentials.',
      name: 'verificationPendingSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Your application is currently locked in read-only mode while under review. You will receive an update once the review is completed.`
  String get underReviewNotice {
    return Intl.message(
      'Your application is currently locked in read-only mode while under review. You will receive an update once the review is completed.',
      name: 'underReviewNotice',
      desc: '',
      args: [],
    );
  }

  /// `Application Needs Attention`
  String get applicationNeedsAttention {
    return Intl.message(
      'Application Needs Attention',
      name: 'applicationNeedsAttention',
      desc: '',
      args: [],
    );
  }

  /// `Moderation Feedback:`
  String get rejectionReasonLabel {
    return Intl.message(
      'Moderation Feedback:',
      name: 'rejectionReasonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Edit & Resubmit`
  String get editAndResubmit {
    return Intl.message(
      'Edit & Resubmit',
      name: 'editAndResubmit',
      desc: '',
      args: [],
    );
  }

  /// `Back to Role Selection`
  String get backToRoleSelection {
    return Intl.message(
      'Back to Role Selection',
      name: 'backToRoleSelection',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Status`
  String get checkStatusAgain {
    return Intl.message(
      'Refresh Status',
      name: 'checkStatusAgain',
      desc: '',
      args: [],
    );
  }

  /// `Resubmit Application`
  String get resubmitApplication {
    return Intl.message(
      'Resubmit Application',
      name: 'resubmitApplication',
      desc: '',
      args: [],
    );
  }

  /// `In-progress application draft restored.`
  String get draftRestored {
    return Intl.message(
      'In-progress application draft restored.',
      name: 'draftRestored',
      desc: '',
      args: [],
    );
  }

  /// `Clear Draft`
  String get clearDraft {
    return Intl.message(
      'Clear Draft',
      name: 'clearDraft',
      desc: '',
      args: [],
    );
  }

  /// `No active application found.`
  String get applicationNotFound {
    return Intl.message(
      'No active application found.',
      name: 'applicationNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get requiredBadge {
    return Intl.message(
      'Required',
      name: 'requiredBadge',
      desc: '',
      args: [],
    );
  }

  /// `Replace File`
  String get replaceFile {
    return Intl.message(
      'Replace File',
      name: 'replaceFile',
      desc: '',
      args: [],
    );
  }

  /// `Additional Certificate {index}`
  String additionalCertificate(Object index) {
    return Intl.message(
      'Additional Certificate $index',
      name: 'additionalCertificate',
      desc: '',
      args: [index],
    );
  }

  /// `Additional certification or accreditation`
  String get additionalCertificateHint {
    return Intl.message(
      'Additional certification or accreditation',
      name: 'additionalCertificateHint',
      desc: '',
      args: [],
    );
  }

  /// `Application submitted for verification!`
  String get applicationSubmittedSuccess {
    return Intl.message(
      'Application submitted for verification!',
      name: 'applicationSubmittedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Application approved! Welcome Coach.`
  String get applicationApprovedWelcome {
    return Intl.message(
      'Application approved! Welcome Coach.',
      name: 'applicationApprovedWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Expected review: 24 - 48 hours`
  String get expectedReviewTime {
    return Intl.message(
      'Expected review: 24 - 48 hours',
      name: 'expectedReviewTime',
      desc: '',
      args: [],
    );
  }

  /// `Application requires credential verification updates.`
  String get defaultRejectionReason {
    return Intl.message(
      'Application requires credential verification updates.',
      name: 'defaultRejectionReason',
      desc: '',
      args: [],
    );
  }

  /// `Quick Availability Templates`
  String get quickAvailabilityTemplates {
    return Intl.message(
      'Quick Availability Templates',
      name: 'quickAvailabilityTemplates',
      desc: '',
      args: [],
    );
  }

  /// `Weekdays (5:00 PM - 10:00 PM)`
  String get availTemplateWeekdays {
    return Intl.message(
      'Weekdays (5:00 PM - 10:00 PM)',
      name: 'availTemplateWeekdays',
      desc: '',
      args: [],
    );
  }

  /// `Mornings (6:00 AM - 12:00 PM)`
  String get availTemplateMornings {
    return Intl.message(
      'Mornings (6:00 AM - 12:00 PM)',
      name: 'availTemplateMornings',
      desc: '',
      args: [],
    );
  }

  /// `Weekends (9:00 AM - 6:00 PM)`
  String get availTemplateWeekends {
    return Intl.message(
      'Weekends (9:00 AM - 6:00 PM)',
      name: 'availTemplateWeekends',
      desc: '',
      args: [],
    );
  }

  /// `Full-time Flexible (Daily)`
  String get availTemplateFullTime {
    return Intl.message(
      'Full-time Flexible (Daily)',
      name: 'availTemplateFullTime',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get reviewLocation {
    return Intl.message(
      'Location',
      name: 'reviewLocation',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get reviewSports {
    return Intl.message(
      'Sports',
      name: 'reviewSports',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Rate`
  String get reviewHourlyRate {
    return Intl.message(
      'Hourly Rate',
      name: 'reviewHourlyRate',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get reviewAvailability {
    return Intl.message(
      'Availability',
      name: 'reviewAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Government ID`
  String get reviewGovernmentId {
    return Intl.message(
      'Government ID',
      name: 'reviewGovernmentId',
      desc: '',
      args: [],
    );
  }

  /// `Certificates`
  String get reviewCertificates {
    return Intl.message(
      'Certificates',
      name: 'reviewCertificates',
      desc: '',
      args: [],
    );
  }

  /// `None specified`
  String get reviewNoneSpecified {
    return Intl.message(
      'None specified',
      name: 'reviewNoneSpecified',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 year} other{{count} years}}`
  String reviewYearsCount(num count) {
    return Intl.plural(
      count,
      one: '1 year',
      other: '$count years',
      name: 'reviewYearsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Attached`
  String get reviewAttached {
    return Intl.message(
      'Attached',
      name: 'reviewAttached',
      desc: '',
      args: [],
    );
  }

  /// `Missing`
  String get reviewMissing {
    return Intl.message(
      'Missing',
      name: 'reviewMissing',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 file attached} other{{count} files attached}}`
  String reviewFilesAttached(num count) {
    return Intl.plural(
      count,
      one: '1 file attached',
      other: '$count files attached',
      name: 'reviewFilesAttached',
      desc: '',
      args: [count],
    );
  }

  /// `Please upload a profile photo.`
  String get validationPhotoRequired {
    return Intl.message(
      'Please upload a profile photo.',
      name: 'validationPhotoRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name.`
  String get validationNameRequired {
    return Intl.message(
      'Please enter your full name.',
      name: 'validationNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your country.`
  String get validationCountryRequired {
    return Intl.message(
      'Please enter your country.',
      name: 'validationCountryRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your city.`
  String get validationCityRequired {
    return Intl.message(
      'Please enter your city.',
      name: 'validationCityRequired',
      desc: '',
      args: [],
    );
  }

  /// `Professional bio must be at least 30 characters.`
  String get validationBioMinLength {
    return Intl.message(
      'Professional bio must be at least 30 characters.',
      name: 'validationBioMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one language.`
  String get validationLanguageRequired {
    return Intl.message(
      'Please select at least one language.',
      name: 'validationLanguageRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one sport.`
  String get validationSportRequired {
    return Intl.message(
      'Please select at least one sport.',
      name: 'validationSportRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please specify a valid hourly session rate.`
  String get validationRateRequired {
    return Intl.message(
      'Please specify a valid hourly session rate.',
      name: 'validationRateRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your general availability.`
  String get validationAvailabilityRequired {
    return Intl.message(
      'Please enter your general availability.',
      name: 'validationAvailabilityRequired',
      desc: '',
      args: [],
    );
  }

  /// `Government ID or Passport upload is required.`
  String get validationIdRequired {
    return Intl.message(
      'Government ID or Passport upload is required.',
      name: 'validationIdRequired',
      desc: '',
      args: [],
    );
  }

  /// `At least one coaching certificate or credential is required.`
  String get validationCertRequired {
    return Intl.message(
      'At least one coaching certificate or credential is required.',
      name: 'validationCertRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please check the required fields.`
  String get validationCheckFields {
    return Intl.message(
      'Please check the required fields.',
      name: 'validationCheckFields',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get langArabic {
    return Intl.message(
      'Arabic',
      name: 'langArabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get langEnglish {
    return Intl.message(
      'English',
      name: 'langEnglish',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get langFrench {
    return Intl.message(
      'French',
      name: 'langFrench',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get langSpanish {
    return Intl.message(
      'Spanish',
      name: 'langSpanish',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get langGerman {
    return Intl.message(
      'German',
      name: 'langGerman',
      desc: '',
      args: [],
    );
  }

  /// `Saudi Arabia`
  String get countrySaudiArabia {
    return Intl.message(
      'Saudi Arabia',
      name: 'countrySaudiArabia',
      desc: '',
      args: [],
    );
  }

  /// `United Arab Emirates`
  String get countryUAE {
    return Intl.message(
      'United Arab Emirates',
      name: 'countryUAE',
      desc: '',
      args: [],
    );
  }

  /// `Egypt`
  String get countryEgypt {
    return Intl.message(
      'Egypt',
      name: 'countryEgypt',
      desc: '',
      args: [],
    );
  }

  /// `Kuwait`
  String get countryKuwait {
    return Intl.message(
      'Kuwait',
      name: 'countryKuwait',
      desc: '',
      args: [],
    );
  }

  /// `Qatar`
  String get countryQatar {
    return Intl.message(
      'Qatar',
      name: 'countryQatar',
      desc: '',
      args: [],
    );
  }

  /// `Bahrain`
  String get countryBahrain {
    return Intl.message(
      'Bahrain',
      name: 'countryBahrain',
      desc: '',
      args: [],
    );
  }

  /// `Oman`
  String get countryOman {
    return Intl.message(
      'Oman',
      name: 'countryOman',
      desc: '',
      args: [],
    );
  }

  /// `Jordan`
  String get countryJordan {
    return Intl.message(
      'Jordan',
      name: 'countryJordan',
      desc: '',
      args: [],
    );
  }

  /// `Riyadh`
  String get cityRiyadh {
    return Intl.message(
      'Riyadh',
      name: 'cityRiyadh',
      desc: '',
      args: [],
    );
  }

  /// `Jeddah`
  String get cityJeddah {
    return Intl.message(
      'Jeddah',
      name: 'cityJeddah',
      desc: '',
      args: [],
    );
  }

  /// `Dammam`
  String get cityDammam {
    return Intl.message(
      'Dammam',
      name: 'cityDammam',
      desc: '',
      args: [],
    );
  }

  /// `Mecca`
  String get cityMecca {
    return Intl.message(
      'Mecca',
      name: 'cityMecca',
      desc: '',
      args: [],
    );
  }

  /// `Medina`
  String get cityMedina {
    return Intl.message(
      'Medina',
      name: 'cityMedina',
      desc: '',
      args: [],
    );
  }

  /// `Khobar`
  String get cityKhobar {
    return Intl.message(
      'Khobar',
      name: 'cityKhobar',
      desc: '',
      args: [],
    );
  }

  /// `Dubai`
  String get cityDubai {
    return Intl.message(
      'Dubai',
      name: 'cityDubai',
      desc: '',
      args: [],
    );
  }

  /// `Abu Dhabi`
  String get cityAbuDhabi {
    return Intl.message(
      'Abu Dhabi',
      name: 'cityAbuDhabi',
      desc: '',
      args: [],
    );
  }

  /// `Sharjah`
  String get citySharjah {
    return Intl.message(
      'Sharjah',
      name: 'citySharjah',
      desc: '',
      args: [],
    );
  }

  /// `Ajman`
  String get cityAjman {
    return Intl.message(
      'Ajman',
      name: 'cityAjman',
      desc: '',
      args: [],
    );
  }

  /// `Ras Al Khaimah`
  String get cityRasAlKhaimah {
    return Intl.message(
      'Ras Al Khaimah',
      name: 'cityRasAlKhaimah',
      desc: '',
      args: [],
    );
  }

  /// `Cairo`
  String get cityCairo {
    return Intl.message(
      'Cairo',
      name: 'cityCairo',
      desc: '',
      args: [],
    );
  }

  /// `Alexandria`
  String get cityAlexandria {
    return Intl.message(
      'Alexandria',
      name: 'cityAlexandria',
      desc: '',
      args: [],
    );
  }

  /// `Giza`
  String get cityGiza {
    return Intl.message(
      'Giza',
      name: 'cityGiza',
      desc: '',
      args: [],
    );
  }

  /// `Mansoura`
  String get cityMansoura {
    return Intl.message(
      'Mansoura',
      name: 'cityMansoura',
      desc: '',
      args: [],
    );
  }

  /// `Tanta`
  String get cityTanta {
    return Intl.message(
      'Tanta',
      name: 'cityTanta',
      desc: '',
      args: [],
    );
  }

  /// `Aswan`
  String get cityAswan {
    return Intl.message(
      'Aswan',
      name: 'cityAswan',
      desc: '',
      args: [],
    );
  }

  /// `Kuwait City`
  String get cityKuwaitCity {
    return Intl.message(
      'Kuwait City',
      name: 'cityKuwaitCity',
      desc: '',
      args: [],
    );
  }

  /// `Hawally`
  String get cityHawally {
    return Intl.message(
      'Hawally',
      name: 'cityHawally',
      desc: '',
      args: [],
    );
  }

  /// `Salmiya`
  String get citySalmiya {
    return Intl.message(
      'Salmiya',
      name: 'citySalmiya',
      desc: '',
      args: [],
    );
  }

  /// `Al Ahmadi`
  String get cityAlAhmadi {
    return Intl.message(
      'Al Ahmadi',
      name: 'cityAlAhmadi',
      desc: '',
      args: [],
    );
  }

  /// `Doha`
  String get cityDoha {
    return Intl.message(
      'Doha',
      name: 'cityDoha',
      desc: '',
      args: [],
    );
  }

  /// `Al Rayyan`
  String get cityAlRayyan {
    return Intl.message(
      'Al Rayyan',
      name: 'cityAlRayyan',
      desc: '',
      args: [],
    );
  }

  /// `Al Wakrah`
  String get cityAlWakrah {
    return Intl.message(
      'Al Wakrah',
      name: 'cityAlWakrah',
      desc: '',
      args: [],
    );
  }

  /// `Al Khor`
  String get cityAlKhor {
    return Intl.message(
      'Al Khor',
      name: 'cityAlKhor',
      desc: '',
      args: [],
    );
  }

  /// `Manama`
  String get cityManama {
    return Intl.message(
      'Manama',
      name: 'cityManama',
      desc: '',
      args: [],
    );
  }

  /// `Riffa`
  String get cityRiffa {
    return Intl.message(
      'Riffa',
      name: 'cityRiffa',
      desc: '',
      args: [],
    );
  }

  /// `Muharraq`
  String get cityMuharraq {
    return Intl.message(
      'Muharraq',
      name: 'cityMuharraq',
      desc: '',
      args: [],
    );
  }

  /// `Hamad Town`
  String get cityHamadTown {
    return Intl.message(
      'Hamad Town',
      name: 'cityHamadTown',
      desc: '',
      args: [],
    );
  }

  /// `Muscat`
  String get cityMuscat {
    return Intl.message(
      'Muscat',
      name: 'cityMuscat',
      desc: '',
      args: [],
    );
  }

  /// `Salalah`
  String get citySalalah {
    return Intl.message(
      'Salalah',
      name: 'citySalalah',
      desc: '',
      args: [],
    );
  }

  /// `Sohar`
  String get citySohar {
    return Intl.message(
      'Sohar',
      name: 'citySohar',
      desc: '',
      args: [],
    );
  }

  /// `Nizwa`
  String get cityNizwa {
    return Intl.message(
      'Nizwa',
      name: 'cityNizwa',
      desc: '',
      args: [],
    );
  }

  /// `Amman`
  String get cityAmman {
    return Intl.message(
      'Amman',
      name: 'cityAmman',
      desc: '',
      args: [],
    );
  }

  /// `Zarqa`
  String get cityZarqa {
    return Intl.message(
      'Zarqa',
      name: 'cityZarqa',
      desc: '',
      args: [],
    );
  }

  /// `Irbid`
  String get cityIrbid {
    return Intl.message(
      'Irbid',
      name: 'cityIrbid',
      desc: '',
      args: [],
    );
  }

  /// `Aqaba`
  String get cityAqaba {
    return Intl.message(
      'Aqaba',
      name: 'cityAqaba',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account?`
  String get deleteAccountConfirmationTitle {
    return Intl.message(
      'Delete Account?',
      name: 'deleteAccountConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? All your data and profile settings will be permanently removed. This action cannot be undone.`
  String get deleteAccountConfirmationMessage {
    return Intl.message(
      'Are you sure you want to delete your account? All your data and profile settings will be permanently removed. This action cannot be undone.',
      name: 'deleteAccountConfirmationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete Account`
  String get deleteAccountConfirm {
    return Intl.message(
      'Yes, Delete Account',
      name: 'deleteAccountConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been deleted successfully.`
  String get accountDeletedSuccess {
    return Intl.message(
      'Your account has been deleted successfully.',
      name: 'accountDeletedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Coach Dashboard`
  String get fakeCoachDashboardTitle {
    return Intl.message(
      'Coach Dashboard',
      name: 'fakeCoachDashboardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Coach! This is a test screen to verify navigation, authentication, and role flows.`
  String get fakeCoachDashboardSubtitle {
    return Intl.message(
      'Welcome Coach! This is a test screen to verify navigation, authentication, and role flows.',
      name: 'fakeCoachDashboardSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Trainee Home`
  String get fakeTraineeHomeTitle {
    return Intl.message(
      'Trainee Home',
      name: 'fakeTraineeHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Trainee! This is a test screen to verify navigation, authentication, and role flows.`
  String get fakeTraineeHomeSubtitle {
    return Intl.message(
      'Welcome Trainee! This is a test screen to verify navigation, authentication, and role flows.',
      name: 'fakeTraineeHomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Test Mode`
  String get testModeBadge {
    return Intl.message(
      'Test Mode',
      name: 'testModeBadge',
      desc: '',
      args: [],
    );
  }

  /// `Signed in as: {email}`
  String currentUserInfo(Object email) {
    return Intl.message(
      'Signed in as: $email',
      name: 'currentUserInfo',
      desc: '',
      args: [email],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Choose Photo Source`
  String get choosePhotoSource {
    return Intl.message(
      'Choose Photo Source',
      name: 'choosePhotoSource',
      desc: '',
      args: [],
    );
  }

  /// `Uploading photo...`
  String get uploadingPhoto {
    return Intl.message(
      'Uploading photo...',
      name: 'uploadingPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Photo uploaded successfully`
  String get photoUploadedSuccess {
    return Intl.message(
      'Photo uploaded successfully',
      name: 'photoUploadedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to upload photo. Please try again.`
  String get photoUploadFailed {
    return Intl.message(
      'Failed to upload photo. Please try again.',
      name: 'photoUploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Remove Photo`
  String get removePhoto {
    return Intl.message(
      'Remove Photo',
      name: 'removePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Select the days and hours you're available for training.`
  String get selectDaysAndHours {
    return Intl.message(
      'Select the days and hours you\'re available for training.',
      name: 'selectDaysAndHours',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message(
      'Unavailable',
      name: 'unavailable',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get fromTime {
    return Intl.message(
      'From',
      name: 'fromTime',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get toTime {
    return Intl.message(
      'To',
      name: 'toTime',
      desc: '',
      args: [],
    );
  }

  /// `No days selected`
  String get noDaysSelected {
    return Intl.message(
      'No days selected',
      name: 'noDaysSelected',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get dayMon {
    return Intl.message(
      'Mon',
      name: 'dayMon',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get dayTue {
    return Intl.message(
      'Tue',
      name: 'dayTue',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get dayWed {
    return Intl.message(
      'Wed',
      name: 'dayWed',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get dayThu {
    return Intl.message(
      'Thu',
      name: 'dayThu',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get dayFri {
    return Intl.message(
      'Fri',
      name: 'dayFri',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get daySat {
    return Intl.message(
      'Sat',
      name: 'daySat',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get daySun {
    return Intl.message(
      'Sun',
      name: 'daySun',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get dayMonday {
    return Intl.message(
      'Monday',
      name: 'dayMonday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get dayTuesday {
    return Intl.message(
      'Tuesday',
      name: 'dayTuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get dayWednesday {
    return Intl.message(
      'Wednesday',
      name: 'dayWednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get dayThursday {
    return Intl.message(
      'Thursday',
      name: 'dayThursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get dayFriday {
    return Intl.message(
      'Friday',
      name: 'dayFriday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get daySaturday {
    return Intl.message(
      'Saturday',
      name: 'daySaturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get daySunday {
    return Intl.message(
      'Sunday',
      name: 'daySunday',
      desc: '',
      args: [],
    );
  }

  /// `Pricing`
  String get stepPricing {
    return Intl.message(
      'Pricing',
      name: 'stepPricing',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Availability`
  String get stepAvailability {
    return Intl.message(
      'Weekly Availability',
      name: 'stepAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Set your session price and preferred currency`
  String get pricingStepSubtitle {
    return Intl.message(
      'Set your session price and preferred currency',
      name: 'pricingStepSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Set a price per session.`
  String get pricingTipText {
    return Intl.message(
      'Set a price per session.',
      name: 'pricingTipText',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Select Currency`
  String get selectCurrency {
    return Intl.message(
      'Select Currency',
      name: 'selectCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Price per Session`
  String get pricePerSession {
    return Intl.message(
      'Price per Session',
      name: 'pricePerSession',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 150`
  String get pricePerSessionHint {
    return Intl.message(
      'e.g. 150',
      name: 'pricePerSessionHint',
      desc: '',
      args: [],
    );
  }

  /// `/ session`
  String get perSessionUnit {
    return Intl.message(
      '/ session',
      name: 'perSessionUnit',
      desc: '',
      args: [],
    );
  }

  /// `Set your weekly training schedule and working hours`
  String get availabilityStepSubtitle {
    return Intl.message(
      'Set your weekly training schedule and working hours',
      name: 'availabilityStepSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Supporting Document`
  String get addSupportingDocument {
    return Intl.message(
      'Add Supporting Document',
      name: 'addSupportingDocument',
      desc: '',
      args: [],
    );
  }

  /// `Supporting Document`
  String get supportingDocument {
    return Intl.message(
      'Supporting Document',
      name: 'supportingDocument',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Uploading...`
  String get uploading {
    return Intl.message(
      'Uploading...',
      name: 'uploading',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 28`
  String get ageHint {
    return Intl.message(
      'e.g. 28',
      name: 'ageHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid age (18 - 80).`
  String get validationAgeRequired {
    return Intl.message(
      'Please enter a valid age (18 - 80).',
      name: 'validationAgeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please select your gender.`
  String get validationGenderRequired {
    return Intl.message(
      'Please select your gender.',
      name: 'validationGenderRequired',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get reviewAge {
    return Intl.message(
      'Age',
      name: 'reviewAge',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get reviewGender {
    return Intl.message(
      'Gender',
      name: 'reviewGender',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed. Please try again later`
  String get uploadFailed {
    return Intl.message(
      'Upload failed. Please try again later',
      name: 'uploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Choose Document Source`
  String get chooseDocumentSource {
    return Intl.message(
      'Choose Document Source',
      name: 'chooseDocumentSource',
      desc: '',
      args: [],
    );
  }

  /// `PDF Document`
  String get pdfDocument {
    return Intl.message(
      'PDF Document',
      name: 'pdfDocument',
      desc: '',
      args: [],
    );
  }

  /// `Remove Document`
  String get removeDocument {
    return Intl.message(
      'Remove Document',
      name: 'removeDocument',
      desc: '',
      args: [],
    );
  }

  /// `Document uploaded successfully`
  String get documentUploadedSuccess {
    return Intl.message(
      'Document uploaded successfully',
      name: 'documentUploadedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `PDF Document Selected`
  String get pdfUploaded {
    return Intl.message(
      'PDF Document Selected',
      name: 'pdfUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Account Suspended`
  String get coachSuspendedTitle {
    return Intl.message(
      'Account Suspended',
      name: 'coachSuspendedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your coach account has been suspended by administration.`
  String get coachSuspendedSubtitle {
    return Intl.message(
      'Your coach account has been suspended by administration.',
      name: 'coachSuspendedSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Access to coach features has been restricted. If you believe this is an error or need more information, please contact our support team.`
  String get coachSuspendedNotice {
    return Intl.message(
      'Access to coach features has been restricted. If you believe this is an error or need more information, please contact our support team.',
      name: 'coachSuspendedNotice',
      desc: '',
      args: [],
    );
  }

  /// `Contact Support`
  String get contactSupport {
    return Intl.message(
      'Contact Support',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Support Assistance`
  String get supportModalTitle {
    return Intl.message(
      'Support Assistance',
      name: 'supportModalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our support team is available to assist you with your account and application inquiries.`
  String get supportModalDesc {
    return Intl.message(
      'Our support team is available to assist you with your account and application inquiries.',
      name: 'supportModalDesc',
      desc: '',
      args: [],
    );
  }

  /// `support@coachhub.app`
  String get supportEmail {
    return Intl.message(
      'support@coachhub.app',
      name: 'supportEmail',
      desc: '',
      args: [],
    );
  }

  /// `Copy Email`
  String get copyEmail {
    return Intl.message(
      'Copy Email',
      name: 'copyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Suspended`
  String get suspendedStatusBadge {
    return Intl.message(
      'Suspended',
      name: 'suspendedStatusBadge',
      desc: '',
      args: [],
    );
  }

  /// `Search coaches or sports...`
  String get searchCoaches {
    return Intl.message(
      'Search coaches or sports...',
      name: 'searchCoaches',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allSports {
    return Intl.message(
      'All',
      name: 'allSports',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message(
      'Filters',
      name: 'filters',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get applyFilters {
    return Intl.message(
      'Apply Filters',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Price Range`
  String get priceRange {
    return Intl.message(
      'Price Range',
      name: 'priceRange',
      desc: '',
      args: [],
    );
  }

  /// `{count} yrs exp`
  String experienceYearsCount(Object count) {
    return Intl.message(
      '$count yrs exp',
      name: 'experienceYearsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Minimum Experience`
  String get minExperienceYears {
    return Intl.message(
      'Minimum Experience',
      name: 'minExperienceYears',
      desc: '',
      args: [],
    );
  }

  /// `Any experience`
  String get anyExperience {
    return Intl.message(
      'Any experience',
      name: 'anyExperience',
      desc: '',
      args: [],
    );
  }

  /// `Coach Gender`
  String get coachGender {
    return Intl.message(
      'Coach Gender',
      name: 'coachGender',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allGenders {
    return Intl.message(
      'All',
      name: 'allGenders',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get maleOnly {
    return Intl.message(
      'Male',
      name: 'maleOnly',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get femaleOnly {
    return Intl.message(
      'Female',
      name: 'femaleOnly',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Rating`
  String get minimumRating {
    return Intl.message(
      'Minimum Rating',
      name: 'minimumRating',
      desc: '',
      args: [],
    );
  }

  /// `Any rating`
  String get anyRating {
    return Intl.message(
      'Any rating',
      name: 'anyRating',
      desc: '',
      args: [],
    );
  }

  /// `Sort By`
  String get sortBy {
    return Intl.message(
      'Sort By',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get sortRecommended {
    return Intl.message(
      'Recommended',
      name: 'sortRecommended',
      desc: '',
      args: [],
    );
  }

  /// `Price: Low to High`
  String get sortPriceLowToHigh {
    return Intl.message(
      'Price: Low to High',
      name: 'sortPriceLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Price: High to Low`
  String get sortPriceHighToLow {
    return Intl.message(
      'Price: High to Low',
      name: 'sortPriceHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Rating: Highest First`
  String get sortRatingHighToLow {
    return Intl.message(
      'Rating: Highest First',
      name: 'sortRatingHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Most Experienced`
  String get sortExperienceHighToLow {
    return Intl.message(
      'Most Experienced',
      name: 'sortExperienceHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `No coaches found`
  String get noCoachesFound {
    return Intl.message(
      'No coaches found',
      name: 'noCoachesFound',
      desc: '',
      args: [],
    );
  }

  /// `Try adjusting your search or filters to find available coaches.`
  String get noCoachesFoundDesc {
    return Intl.message(
      'Try adjusting your search or filters to find available coaches.',
      name: 'noCoachesFoundDesc',
      desc: '',
      args: [],
    );
  }

  /// `Clear Filters`
  String get clearFilters {
    return Intl.message(
      'Clear Filters',
      name: 'clearFilters',
      desc: '',
      args: [],
    );
  }

  /// `Verified Coach`
  String get verifiedCoach {
    return Intl.message(
      'Verified Coach',
      name: 'verifiedCoach',
      desc: '',
      args: [],
    );
  }

  /// `{count} reviews`
  String reviewsCount(Object count) {
    return Intl.message(
      '$count reviews',
      name: 'reviewsCount',
      desc: '',
      args: [count],
    );
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get noReviewsYet {
    return Intl.message(
      'New',
      name: 'noReviewsYet',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load coaches. Tap to retry.`
  String get errorLoadingCoaches {
    return Intl.message(
      'Failed to load coaches. Tap to retry.',
      name: 'errorLoadingCoaches',
      desc: '',
      args: [],
    );
  }

  /// `Email copied to clipboard`
  String get emailCopied {
    return Intl.message(
      'Email copied to clipboard',
      name: 'emailCopied',
      desc: '',
      args: [],
    );
  }

  /// `Coach Profile`
  String get coachProfileDetails {
    return Intl.message(
      'Coach Profile',
      name: 'coachProfileDetails',
      desc: '',
      args: [],
    );
  }

  /// `About Coach`
  String get aboutCoach {
    return Intl.message(
      'About Coach',
      name: 'aboutCoach',
      desc: '',
      args: [],
    );
  }

  /// `Credentials & Experience`
  String get credentialsAndQualifications {
    return Intl.message(
      'Credentials & Experience',
      name: 'credentialsAndQualifications',
      desc: '',
      args: [],
    );
  }

  /// `Spoken Languages`
  String get spokenLanguages {
    return Intl.message(
      'Spoken Languages',
      name: 'spokenLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Certifications`
  String get certifications {
    return Intl.message(
      'Certifications',
      name: 'certifications',
      desc: '',
      args: [],
    );
  }

  /// `Verified Credentials on File`
  String get verifiedCertifications {
    return Intl.message(
      'Verified Credentials on File',
      name: 'verifiedCertifications',
      desc: '',
      args: [],
    );
  }

  /// `Session Pricing`
  String get sessionPricing {
    return Intl.message(
      'Session Pricing',
      name: 'sessionPricing',
      desc: '',
      args: [],
    );
  }

  /// `What's Included`
  String get whatsIncluded {
    return Intl.message(
      'What\'s Included',
      name: 'whatsIncluded',
      desc: '',
      args: [],
    );
  }

  /// `1-on-1 private coaching`
  String get oneOnOneTraining {
    return Intl.message(
      '1-on-1 private coaching',
      name: 'oneOnOneTraining',
      desc: '',
      args: [],
    );
  }

  /// `Customized fitness guidance`
  String get customWorkoutPlan {
    return Intl.message(
      'Customized fitness guidance',
      name: 'customWorkoutPlan',
      desc: '',
      args: [],
    );
  }

  /// `Direct scheduling & support`
  String get directSupport {
    return Intl.message(
      'Direct scheduling & support',
      name: 'directSupport',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Availability`
  String get weeklyAvailabilityTitle {
    return Intl.message(
      'Weekly Availability',
      name: 'weeklyAvailabilityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Request Training Session`
  String get requestTraining {
    return Intl.message(
      'Request Training Session',
      name: 'requestTraining',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get dayAvailable {
    return Intl.message(
      'Available',
      name: 'dayAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get dayUnavailable {
    return Intl.message(
      'Off',
      name: 'dayUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `No fixed schedule listed. Discuss upon request.`
  String get noAvailabilityListed {
    return Intl.message(
      'No fixed schedule listed. Discuss upon request.',
      name: 'noAvailabilityListed',
      desc: '',
      args: [],
    );
  }

  /// `View Certificate`
  String get viewCertificate {
    return Intl.message(
      'View Certificate',
      name: 'viewCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load coach profile. Tap to retry.`
  String get errorLoadingCoachProfile {
    return Intl.message(
      'Failed to load coach profile. Tap to retry.',
      name: 'errorLoadingCoachProfile',
      desc: '',
      args: [],
    );
  }

  /// `Certified professional coach dedicated to helping you achieve your personal fitness and performance goals.`
  String get defaultCoachBio {
    return Intl.message(
      'Certified professional coach dedicated to helping you achieve your personal fitness and performance goals.',
      name: 'defaultCoachBio',
      desc: '',
      args: [],
    );
  }

  /// `Booking request flow opens next!`
  String get bookingFeatureComingSoon {
    return Intl.message(
      'Booking request flow opens next!',
      name: 'bookingFeatureComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Specialties`
  String get specialties {
    return Intl.message(
      'Specialties',
      name: 'specialties',
      desc: '',
      args: [],
    );
  }

  /// `{age} yrs`
  String coachAgeYears(Object age) {
    return Intl.message(
      '$age yrs',
      name: 'coachAgeYears',
      desc: '',
      args: [age],
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
