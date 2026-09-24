// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: '1 sport selected', other: '${count} sports selected')}";

  static String m1(current, total) => "STEP ${current} OF ${total}";

  static String m2(name) => "Welcome back, ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountCreated":
            MessageLookupByLibrary.simpleMessage("Account Created"),
        "accountCreatedMessage": MessageLookupByLibrary.simpleMessage(
            "A verification link has been sent to your email. Please verify before signing in."),
        "addPhotoPrompt": MessageLookupByLibrary.simpleMessage(
            "Add a photo so coaches know who you are"),
        "advanced": MessageLookupByLibrary.simpleMessage("Advanced"),
        "advancedDesc": MessageLookupByLibrary.simpleMessage(
            "Experienced and want to level up"),
        "allSetSubtitle": MessageLookupByLibrary.simpleMessage(
            "Your trainee profile is ready. Start discovering coaches who match your sport and goals."),
        "allSetTitle": MessageLookupByLibrary.simpleMessage("You\'re all set!"),
        "appName": MessageLookupByLibrary.simpleMessage("CoachHub"),
        "apple": MessageLookupByLibrary.simpleMessage("Apple"),
        "backToSignIn": MessageLookupByLibrary.simpleMessage("Back to Sign In"),
        "beginner": MessageLookupByLibrary.simpleMessage("Beginner"),
        "beginnerDesc":
            MessageLookupByLibrary.simpleMessage("Just starting out"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "chooseAccountType":
            MessageLookupByLibrary.simpleMessage("Choose Account Type"),
        "chooseYourRole":
            MessageLookupByLibrary.simpleMessage("Choose Your Role"),
        "cityOrRegionOptional": MessageLookupByLibrary.simpleMessage(
            "Your city or region (optional)"),
        "coachDashboard":
            MessageLookupByLibrary.simpleMessage("Coach Dashboard"),
        "coachDashboardPlaceholder": MessageLookupByLibrary.simpleMessage(
            "Coach Onboarding & Dashboard (Phase 3)"),
        "coachDesc": MessageLookupByLibrary.simpleMessage(
            "Offer your sports training services, manage requests, and grow your clients."),
        "competitionPrep":
            MessageLookupByLibrary.simpleMessage("Competition Prep"),
        "completeProfile":
            MessageLookupByLibrary.simpleMessage("Complete Profile"),
        "completeYourProfile":
            MessageLookupByLibrary.simpleMessage("Complete Your Profile"),
        "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
        "demoEndsHere": MessageLookupByLibrary.simpleMessage(
            "(Demo ends here — Home screen is Phase 2)"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "emailHint": MessageLookupByLibrary.simpleMessage("name@example.com"),
        "emailVerificationMessage": MessageLookupByLibrary.simpleMessage(
            "Please verify your email address to continue."),
        "emailVerificationRequired":
            MessageLookupByLibrary.simpleMessage("Email Verification Required"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "female": MessageLookupByLibrary.simpleMessage("Female"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
        "fullNameHint": MessageLookupByLibrary.simpleMessage("e.g. Ahmed Ali"),
        "funRecreation":
            MessageLookupByLibrary.simpleMessage("Fun & Recreation"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender"),
        "generalFitness":
            MessageLookupByLibrary.simpleMessage("General Fitness"),
        "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
        "getStartedNow": MessageLookupByLibrary.simpleMessage("Get Started"),
        "goToSignIn": MessageLookupByLibrary.simpleMessage("Go to Sign In"),
        "goalSubtitle": MessageLookupByLibrary.simpleMessage(
            "What do you want to achieve?"),
        "google": MessageLookupByLibrary.simpleMessage("Google"),
        "howWillYouUse": MessageLookupByLibrary.simpleMessage(
            "How will you be using CoachHub?"),
        "iAmCoach": MessageLookupByLibrary.simpleMessage("I am a Coach"),
        "iAmTrainee": MessageLookupByLibrary.simpleMessage("I am a Trainee"),
        "intermediate": MessageLookupByLibrary.simpleMessage("Intermediate"),
        "intermediateDesc":
            MessageLookupByLibrary.simpleMessage("Some experience"),
        "levelSubtitle": MessageLookupByLibrary.simpleMessage(
            "This helps us match you with the right coaches"),
        "male": MessageLookupByLibrary.simpleMessage("Male"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "onboardingBadge1":
            MessageLookupByLibrary.simpleMessage("Certified Coaches"),
        "onboardingBadge2":
            MessageLookupByLibrary.simpleMessage("Flexible Schedules"),
        "onboardingBadge3":
            MessageLookupByLibrary.simpleMessage("Real-Time Tracking"),
        "onboardingDesc1": MessageLookupByLibrary.simpleMessage(
            "Connect with certified personal trainers specialized in Gym, Boxing, Swimming, Tennis, and more."),
        "onboardingDesc2": MessageLookupByLibrary.simpleMessage(
            "Schedule private sessions and follow custom workout and nutrition plans that match your lifestyle."),
        "onboardingDesc3": MessageLookupByLibrary.simpleMessage(
            "Monitor your performance stats, workout streaks, and celebrate milestones with coach guidance."),
        "onboardingTitle1":
            MessageLookupByLibrary.simpleMessage("Find Your Expert Coach"),
        "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
            "Personalized Plans & Booking"),
        "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
            "Track Progress & Reach Goals"),
        "orContinueWith":
            MessageLookupByLibrary.simpleMessage("or continue with"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "passwordLengthHint":
            MessageLookupByLibrary.simpleMessage("At least 6 characters"),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "pleaseEnterEmail":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("Please enter your name"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "preferNotToSay":
            MessageLookupByLibrary.simpleMessage("Prefer not to say"),
        "resend": MessageLookupByLibrary.simpleMessage("Resend"),
        "resendEmail": MessageLookupByLibrary.simpleMessage("Resend Email"),
        "resetLinkSent":
            MessageLookupByLibrary.simpleMessage("Reset Link Sent"),
        "resetLinkSentMessage": MessageLookupByLibrary.simpleMessage(
            "A password reset link has been sent to your email. Please check your inbox."),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
            "Enter your email address and we will send you a link to reset your password."),
        "selectSportsSubtitle": MessageLookupByLibrary.simpleMessage(
            "Select one or more sports you want to train in"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("Send Reset Link"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "Sign in to access your sports platform"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "Join CoachHub to get started today"),
        "skillDevelopment":
            MessageLookupByLibrary.simpleMessage("Skill Development"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "skipForNow": MessageLookupByLibrary.simpleMessage("Skip for now"),
        "splashSubtitle": MessageLookupByLibrary.simpleMessage(
            "Find Your Perfect Sports Coach"),
        "sportBasketball": MessageLookupByLibrary.simpleMessage("Basketball"),
        "sportBoxing": MessageLookupByLibrary.simpleMessage("Boxing"),
        "sportCycling": MessageLookupByLibrary.simpleMessage("Cycling"),
        "sportFootball": MessageLookupByLibrary.simpleMessage("Football"),
        "sportGym": MessageLookupByLibrary.simpleMessage("Gym"),
        "sportMartialArts":
            MessageLookupByLibrary.simpleMessage("Martial Arts"),
        "sportOther": MessageLookupByLibrary.simpleMessage("Other"),
        "sportRunning": MessageLookupByLibrary.simpleMessage("Running"),
        "sportSwimming": MessageLookupByLibrary.simpleMessage("Swimming"),
        "sportTennis": MessageLookupByLibrary.simpleMessage("Tennis"),
        "sportVolleyball": MessageLookupByLibrary.simpleMessage("Volleyball"),
        "sportYoga": MessageLookupByLibrary.simpleMessage("Yoga"),
        "sportsSelected": m0,
        "startExploringCoaches":
            MessageLookupByLibrary.simpleMessage("Start Exploring Coaches"),
        "stepOf": m1,
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "tapToUploadPhoto":
            MessageLookupByLibrary.simpleMessage("Tap to upload photo"),
        "traineeDesc": MessageLookupByLibrary.simpleMessage(
            "Find qualified coaches, book training sessions, and reach your goals."),
        "traineeDiscovery":
            MessageLookupByLibrary.simpleMessage("Trainee Discovery"),
        "traineeMarketplacePlaceholder": MessageLookupByLibrary.simpleMessage(
            "Trainee Marketplace Screen (Phase 3)"),
        "traineeSetup": MessageLookupByLibrary.simpleMessage("Trainee Setup"),
        "verificationEmailSent": MessageLookupByLibrary.simpleMessage(
            "Verification email sent successfully!"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "weightLoss": MessageLookupByLibrary.simpleMessage("Weight Loss"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
        "welcomeBackUser": m2,
        "yourGoal": MessageLookupByLibrary.simpleMessage("Your Goal"),
        "yourLevel": MessageLookupByLibrary.simpleMessage("Your Level"),
        "yourProfile": MessageLookupByLibrary.simpleMessage("Your Profile"),
        "yourSports": MessageLookupByLibrary.simpleMessage("Your Sports")
      };
}
