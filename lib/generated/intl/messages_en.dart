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

  static String m0(index) => "Additional Certificate ${index}";

  static String m1(email) => "Signed in as: ${email}";

  static String m2(count) =>
      "${Intl.plural(count, one: '1 file attached', other: '${count} files attached')}";

  static String m3(count) =>
      "${Intl.plural(count, one: '1 year', other: '${count} years')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 sport selected', other: '${count} sports selected')}";

  static String m5(current, total) => "STEP ${current} OF ${total}";

  static String m6(name) => "Welcome back, ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountCreated":
            MessageLookupByLibrary.simpleMessage("Account Created"),
        "accountCreatedMessage": MessageLookupByLibrary.simpleMessage(
            "A verification link has been sent to your email. Please verify before signing in."),
        "accountDeletedSuccess": MessageLookupByLibrary.simpleMessage(
            "Your account has been deleted successfully."),
        "addPhotoPrompt": MessageLookupByLibrary.simpleMessage(
            "Add a photo so coaches know who you are"),
        "addSupportingDocument":
            MessageLookupByLibrary.simpleMessage("Add Supporting Document"),
        "additionalCertificate": m0,
        "additionalCertificateHint": MessageLookupByLibrary.simpleMessage(
            "Additional certification or accreditation"),
        "advanced": MessageLookupByLibrary.simpleMessage("Advanced"),
        "advancedDesc": MessageLookupByLibrary.simpleMessage(
            "Experienced and want to level up"),
        "age": MessageLookupByLibrary.simpleMessage("Age"),
        "ageHint": MessageLookupByLibrary.simpleMessage("e.g. 28"),
        "allSetSubtitle": MessageLookupByLibrary.simpleMessage(
            "Your trainee profile is ready. Start discovering coaches who match your sport and goals."),
        "allSetTitle": MessageLookupByLibrary.simpleMessage("You\'re all set!"),
        "appName": MessageLookupByLibrary.simpleMessage("CoachHub"),
        "apple": MessageLookupByLibrary.simpleMessage("Apple"),
        "applicationApprovedWelcome": MessageLookupByLibrary.simpleMessage(
            "Application approved! Welcome Coach."),
        "applicationNeedsAttention":
            MessageLookupByLibrary.simpleMessage("Application Needs Attention"),
        "applicationNotFound": MessageLookupByLibrary.simpleMessage(
            "No active application found."),
        "applicationSubmitted":
            MessageLookupByLibrary.simpleMessage("Application Submitted!"),
        "applicationSubmittedDesc": MessageLookupByLibrary.simpleMessage(
            "Your application has been received and is currently under review by our administration team."),
        "applicationSubmittedSuccess": MessageLookupByLibrary.simpleMessage(
            "Application submitted for verification!"),
        "availTemplateFullTime":
            MessageLookupByLibrary.simpleMessage("Full-time Flexible (Daily)"),
        "availTemplateMornings": MessageLookupByLibrary.simpleMessage(
            "Mornings (6:00 AM - 12:00 PM)"),
        "availTemplateWeekdays": MessageLookupByLibrary.simpleMessage(
            "Weekdays (5:00 PM - 10:00 PM)"),
        "availTemplateWeekends": MessageLookupByLibrary.simpleMessage(
            "Weekends (9:00 AM - 6:00 PM)"),
        "availabilityHint": MessageLookupByLibrary.simpleMessage(
            "e.g. Sun-Thu 5:00 PM - 10:00 PM, Sat 9:00 AM - 2:00 PM"),
        "availabilityRequired": MessageLookupByLibrary.simpleMessage(
            "Please provide your general availability schedule"),
        "availabilityStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "Set your weekly training schedule and working hours"),
        "availabilityTitle": MessageLookupByLibrary.simpleMessage(
            "Weekly Availability Overview"),
        "available": MessageLookupByLibrary.simpleMessage("Available"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "backToRoleSelection":
            MessageLookupByLibrary.simpleMessage("Back to Role Selection"),
        "backToSignIn": MessageLookupByLibrary.simpleMessage("Back to Sign In"),
        "beginner": MessageLookupByLibrary.simpleMessage("Beginner"),
        "beginnerDesc":
            MessageLookupByLibrary.simpleMessage("Just starting out"),
        "bio": MessageLookupByLibrary.simpleMessage("Professional Bio"),
        "bioHint": MessageLookupByLibrary.simpleMessage(
            "Tell trainees about your coaching philosophy, background, and experience (min 30 characters)..."),
        "bioMinLength": MessageLookupByLibrary.simpleMessage(
            "Bio must be at least 30 characters"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "certRequired": MessageLookupByLibrary.simpleMessage(
            "Please upload at least one coaching certificate or degree"),
        "checkStatusAgain":
            MessageLookupByLibrary.simpleMessage("Refresh Status"),
        "chooseAccountType":
            MessageLookupByLibrary.simpleMessage("Choose Account Type"),
        "chooseDocumentSource":
            MessageLookupByLibrary.simpleMessage("Choose Document Source"),
        "choosePhotoSource":
            MessageLookupByLibrary.simpleMessage("Choose Photo Source"),
        "chooseYourRole":
            MessageLookupByLibrary.simpleMessage("Choose Your Role"),
        "city": MessageLookupByLibrary.simpleMessage("City"),
        "cityAbuDhabi": MessageLookupByLibrary.simpleMessage("Abu Dhabi"),
        "cityAjman": MessageLookupByLibrary.simpleMessage("Ajman"),
        "cityAlAhmadi": MessageLookupByLibrary.simpleMessage("Al Ahmadi"),
        "cityAlKhor": MessageLookupByLibrary.simpleMessage("Al Khor"),
        "cityAlRayyan": MessageLookupByLibrary.simpleMessage("Al Rayyan"),
        "cityAlWakrah": MessageLookupByLibrary.simpleMessage("Al Wakrah"),
        "cityAlexandria": MessageLookupByLibrary.simpleMessage("Alexandria"),
        "cityAmman": MessageLookupByLibrary.simpleMessage("Amman"),
        "cityAqaba": MessageLookupByLibrary.simpleMessage("Aqaba"),
        "cityAswan": MessageLookupByLibrary.simpleMessage("Aswan"),
        "cityCairo": MessageLookupByLibrary.simpleMessage("Cairo"),
        "cityDammam": MessageLookupByLibrary.simpleMessage("Dammam"),
        "cityDoha": MessageLookupByLibrary.simpleMessage("Doha"),
        "cityDubai": MessageLookupByLibrary.simpleMessage("Dubai"),
        "cityGiza": MessageLookupByLibrary.simpleMessage("Giza"),
        "cityHamadTown": MessageLookupByLibrary.simpleMessage("Hamad Town"),
        "cityHawally": MessageLookupByLibrary.simpleMessage("Hawally"),
        "cityHint": MessageLookupByLibrary.simpleMessage("e.g. Riyadh, Cairo"),
        "cityIrbid": MessageLookupByLibrary.simpleMessage("Irbid"),
        "cityJeddah": MessageLookupByLibrary.simpleMessage("Jeddah"),
        "cityKhobar": MessageLookupByLibrary.simpleMessage("Khobar"),
        "cityKuwaitCity": MessageLookupByLibrary.simpleMessage("Kuwait City"),
        "cityManama": MessageLookupByLibrary.simpleMessage("Manama"),
        "cityMansoura": MessageLookupByLibrary.simpleMessage("Mansoura"),
        "cityMecca": MessageLookupByLibrary.simpleMessage("Mecca"),
        "cityMedina": MessageLookupByLibrary.simpleMessage("Medina"),
        "cityMuharraq": MessageLookupByLibrary.simpleMessage("Muharraq"),
        "cityMuscat": MessageLookupByLibrary.simpleMessage("Muscat"),
        "cityNizwa": MessageLookupByLibrary.simpleMessage("Nizwa"),
        "cityOrRegionOptional": MessageLookupByLibrary.simpleMessage(
            "Your city or region (optional)"),
        "cityRasAlKhaimah":
            MessageLookupByLibrary.simpleMessage("Ras Al Khaimah"),
        "cityRiffa": MessageLookupByLibrary.simpleMessage("Riffa"),
        "cityRiyadh": MessageLookupByLibrary.simpleMessage("Riyadh"),
        "citySalalah": MessageLookupByLibrary.simpleMessage("Salalah"),
        "citySalmiya": MessageLookupByLibrary.simpleMessage("Salmiya"),
        "citySharjah": MessageLookupByLibrary.simpleMessage("Sharjah"),
        "citySohar": MessageLookupByLibrary.simpleMessage("Sohar"),
        "cityTanta": MessageLookupByLibrary.simpleMessage("Tanta"),
        "cityZarqa": MessageLookupByLibrary.simpleMessage("Zarqa"),
        "clearDraft": MessageLookupByLibrary.simpleMessage("Clear Draft"),
        "coachDashboard":
            MessageLookupByLibrary.simpleMessage("Coach Dashboard"),
        "coachDashboardPlaceholder": MessageLookupByLibrary.simpleMessage(
            "Coach Onboarding & Dashboard (Phase 3)"),
        "coachDesc": MessageLookupByLibrary.simpleMessage(
            "Offer your sports training services, manage requests, and grow your clients."),
        "coachPhotoRequired":
            MessageLookupByLibrary.simpleMessage("Profile photo is required"),
        "coachSetupSubtitle": MessageLookupByLibrary.simpleMessage(
            "Create your professional coach profile and submit verification"),
        "coachSetupTitle":
            MessageLookupByLibrary.simpleMessage("Coach Application"),
        "coachingCertificates": MessageLookupByLibrary.simpleMessage(
            "Coaching Certificate or Degree"),
        "coachingCertificatesHint": MessageLookupByLibrary.simpleMessage(
            "Upload coaching certification, diploma, or sports degree"),
        "competitionPrep":
            MessageLookupByLibrary.simpleMessage("Competition Prep"),
        "completeProfile":
            MessageLookupByLibrary.simpleMessage("Complete Profile"),
        "completeYourProfile":
            MessageLookupByLibrary.simpleMessage("Complete Your Profile"),
        "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
        "country": MessageLookupByLibrary.simpleMessage("Country"),
        "countryBahrain": MessageLookupByLibrary.simpleMessage("Bahrain"),
        "countryEgypt": MessageLookupByLibrary.simpleMessage("Egypt"),
        "countryHint":
            MessageLookupByLibrary.simpleMessage("e.g. Saudi Arabia, Egypt"),
        "countryJordan": MessageLookupByLibrary.simpleMessage("Jordan"),
        "countryKuwait": MessageLookupByLibrary.simpleMessage("Kuwait"),
        "countryOman": MessageLookupByLibrary.simpleMessage("Oman"),
        "countryQatar": MessageLookupByLibrary.simpleMessage("Qatar"),
        "countrySaudiArabia":
            MessageLookupByLibrary.simpleMessage("Saudi Arabia"),
        "countryUAE":
            MessageLookupByLibrary.simpleMessage("United Arab Emirates"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "currencySAR": MessageLookupByLibrary.simpleMessage("SAR / hr"),
        "currentUserInfo": m1,
        "dayFri": MessageLookupByLibrary.simpleMessage("Fri"),
        "dayFriday": MessageLookupByLibrary.simpleMessage("Friday"),
        "dayMon": MessageLookupByLibrary.simpleMessage("Mon"),
        "dayMonday": MessageLookupByLibrary.simpleMessage("Monday"),
        "daySat": MessageLookupByLibrary.simpleMessage("Sat"),
        "daySaturday": MessageLookupByLibrary.simpleMessage("Saturday"),
        "daySun": MessageLookupByLibrary.simpleMessage("Sun"),
        "daySunday": MessageLookupByLibrary.simpleMessage("Sunday"),
        "dayThu": MessageLookupByLibrary.simpleMessage("Thu"),
        "dayThursday": MessageLookupByLibrary.simpleMessage("Thursday"),
        "dayTue": MessageLookupByLibrary.simpleMessage("Tue"),
        "dayTuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "dayWed": MessageLookupByLibrary.simpleMessage("Wed"),
        "dayWednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
        "defaultRejectionReason": MessageLookupByLibrary.simpleMessage(
            "Application requires credential verification updates."),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteAccountConfirm":
            MessageLookupByLibrary.simpleMessage("Yes, Delete Account"),
        "deleteAccountConfirmationMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete your account? All your data and profile settings will be permanently removed. This action cannot be undone."),
        "deleteAccountConfirmationTitle":
            MessageLookupByLibrary.simpleMessage("Delete Account?"),
        "demoEndsHere": MessageLookupByLibrary.simpleMessage(
            "(Demo ends here — Home screen is Phase 2)"),
        "documentUploadedSuccess": MessageLookupByLibrary.simpleMessage(
            "Document uploaded successfully"),
        "draftRestored": MessageLookupByLibrary.simpleMessage(
            "In-progress application draft restored."),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editAndResubmit":
            MessageLookupByLibrary.simpleMessage("Edit & Resubmit"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "emailHint": MessageLookupByLibrary.simpleMessage("name@example.com"),
        "emailVerificationMessage": MessageLookupByLibrary.simpleMessage(
            "Please verify your email address to continue."),
        "emailVerificationRequired":
            MessageLookupByLibrary.simpleMessage("Email Verification Required"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "expectedReviewTime": MessageLookupByLibrary.simpleMessage(
            "Expected review: 24 - 48 hours"),
        "fakeCoachDashboardSubtitle": MessageLookupByLibrary.simpleMessage(
            "Welcome Coach! This is a test screen to verify navigation, authentication, and role flows."),
        "fakeCoachDashboardTitle":
            MessageLookupByLibrary.simpleMessage("Coach Dashboard"),
        "fakeTraineeHomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "Welcome Trainee! This is a test screen to verify navigation, authentication, and role flows."),
        "fakeTraineeHomeTitle":
            MessageLookupByLibrary.simpleMessage("Trainee Home"),
        "female": MessageLookupByLibrary.simpleMessage("Female"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage(
            "File size exceeds 10MB limit"),
        "fileUploaded":
            MessageLookupByLibrary.simpleMessage("Document Selected"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "fromTime": MessageLookupByLibrary.simpleMessage("From"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
        "fullNameHint": MessageLookupByLibrary.simpleMessage("e.g. Ahmed Ali"),
        "funRecreation":
            MessageLookupByLibrary.simpleMessage("Fun & Recreation"),
        "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender"),
        "generalFitness":
            MessageLookupByLibrary.simpleMessage("General Fitness"),
        "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
        "getStartedNow": MessageLookupByLibrary.simpleMessage("Get Started"),
        "goToSignIn": MessageLookupByLibrary.simpleMessage("Go to Sign In"),
        "goalSubtitle": MessageLookupByLibrary.simpleMessage(
            "What do you want to achieve?"),
        "google": MessageLookupByLibrary.simpleMessage("Google"),
        "hourlyRateHint": MessageLookupByLibrary.simpleMessage("e.g. 150"),
        "hourlyRateRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid hourly rate greater than 0"),
        "howWillYouUse": MessageLookupByLibrary.simpleMessage(
            "How will you be using CoachHub?"),
        "iAmCoach": MessageLookupByLibrary.simpleMessage("I am a Coach"),
        "iAmTrainee": MessageLookupByLibrary.simpleMessage("I am a Trainee"),
        "idRequired": MessageLookupByLibrary.simpleMessage(
            "Please upload your government ID"),
        "intermediate": MessageLookupByLibrary.simpleMessage("Intermediate"),
        "intermediateDesc":
            MessageLookupByLibrary.simpleMessage("Some experience"),
        "langArabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "langEnglish": MessageLookupByLibrary.simpleMessage("English"),
        "langFrench": MessageLookupByLibrary.simpleMessage("French"),
        "langGerman": MessageLookupByLibrary.simpleMessage("German"),
        "langSpanish": MessageLookupByLibrary.simpleMessage("Spanish"),
        "languages": MessageLookupByLibrary.simpleMessage("Languages Spoken"),
        "levelSubtitle": MessageLookupByLibrary.simpleMessage(
            "This helps us match you with the right coaches"),
        "male": MessageLookupByLibrary.simpleMessage("Male"),
        "nationalIdHint": MessageLookupByLibrary.simpleMessage(
            "Upload photo or PDF of your National ID or Passport"),
        "nationalIdOrPassport":
            MessageLookupByLibrary.simpleMessage("Government ID or Passport"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "noDaysSelected":
            MessageLookupByLibrary.simpleMessage("No days selected"),
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
        "pdfDocument": MessageLookupByLibrary.simpleMessage("PDF Document"),
        "pdfUploaded":
            MessageLookupByLibrary.simpleMessage("PDF Document Selected"),
        "perSessionUnit": MessageLookupByLibrary.simpleMessage("/ session"),
        "phoneHint": MessageLookupByLibrary.simpleMessage("+966 50 123 4567"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "photoUploadFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to upload photo. Please try again."),
        "photoUploadedSuccess":
            MessageLookupByLibrary.simpleMessage("Photo uploaded successfully"),
        "pleaseEnterEmail":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("Please enter your name"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "pleaseEnterPhone": MessageLookupByLibrary.simpleMessage(
            "Please enter your phone number"),
        "pleaseSelectLanguage": MessageLookupByLibrary.simpleMessage(
            "Please select at least one language"),
        "pleaseSelectSport": MessageLookupByLibrary.simpleMessage(
            "Please select at least one sport"),
        "preferNotToSay":
            MessageLookupByLibrary.simpleMessage("Prefer not to say"),
        "pricePerSession":
            MessageLookupByLibrary.simpleMessage("Price per Session"),
        "pricePerSessionHint": MessageLookupByLibrary.simpleMessage("e.g. 150"),
        "pricingStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "Set your session price and preferred currency"),
        "pricingTipText":
            MessageLookupByLibrary.simpleMessage("Set a price per session."),
        "pricingTitle":
            MessageLookupByLibrary.simpleMessage("Hourly Training Rate"),
        "quickAvailabilityTemplates": MessageLookupByLibrary.simpleMessage(
            "Quick Availability Templates"),
        "rejectionReasonLabel":
            MessageLookupByLibrary.simpleMessage("Moderation Feedback:"),
        "removeDocument":
            MessageLookupByLibrary.simpleMessage("Remove Document"),
        "removePhoto": MessageLookupByLibrary.simpleMessage("Remove Photo"),
        "replaceFile": MessageLookupByLibrary.simpleMessage("Replace File"),
        "requiredBadge": MessageLookupByLibrary.simpleMessage("Required"),
        "resend": MessageLookupByLibrary.simpleMessage("Resend"),
        "resendEmail": MessageLookupByLibrary.simpleMessage("Resend Email"),
        "resetLinkSent":
            MessageLookupByLibrary.simpleMessage("Reset Link Sent"),
        "resetLinkSentMessage": MessageLookupByLibrary.simpleMessage(
            "A password reset link has been sent to your email. Please check your inbox."),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
            "Enter your email address and we will send you a link to reset your password."),
        "resubmitApplication":
            MessageLookupByLibrary.simpleMessage("Resubmit Application"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "reviewAge": MessageLookupByLibrary.simpleMessage("Age"),
        "reviewAttached": MessageLookupByLibrary.simpleMessage("Attached"),
        "reviewAvailability":
            MessageLookupByLibrary.simpleMessage("Availability"),
        "reviewCertificates":
            MessageLookupByLibrary.simpleMessage("Certificates"),
        "reviewFilesAttached": m2,
        "reviewGender": MessageLookupByLibrary.simpleMessage("Gender"),
        "reviewGovernmentId":
            MessageLookupByLibrary.simpleMessage("Government ID"),
        "reviewHourlyRate": MessageLookupByLibrary.simpleMessage("Hourly Rate"),
        "reviewLocation": MessageLookupByLibrary.simpleMessage("Location"),
        "reviewMissing": MessageLookupByLibrary.simpleMessage("Missing"),
        "reviewNoneSpecified":
            MessageLookupByLibrary.simpleMessage("None specified"),
        "reviewSports": MessageLookupByLibrary.simpleMessage("Sports"),
        "reviewSubtitle": MessageLookupByLibrary.simpleMessage(
            "Please verify all details before submitting for moderation."),
        "reviewTitle":
            MessageLookupByLibrary.simpleMessage("Review Your Application"),
        "reviewYearsCount": m3,
        "selectCity": MessageLookupByLibrary.simpleMessage("Select City"),
        "selectCountry": MessageLookupByLibrary.simpleMessage("Select Country"),
        "selectCountryFirst": MessageLookupByLibrary.simpleMessage(
            "Please select a country first"),
        "selectCurrency":
            MessageLookupByLibrary.simpleMessage("Select Currency"),
        "selectDaysAndHours": MessageLookupByLibrary.simpleMessage(
            "Select the days and hours you\'re available for training."),
        "selectLanguages":
            MessageLookupByLibrary.simpleMessage("Select Languages"),
        "selectSportsSubtitle": MessageLookupByLibrary.simpleMessage(
            "Select one or more sports you want to train in"),
        "selectSportsYouCoach":
            MessageLookupByLibrary.simpleMessage("Select the sports you coach"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("Send Reset Link"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "Sign in to access your sports platform"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "Join CoachHub to get started today"),
        "skillDevelopment":
            MessageLookupByLibrary.simpleMessage("Skill Development"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "skipForNow": MessageLookupByLibrary.simpleMessage("Skip for now"),
        "specialties":
            MessageLookupByLibrary.simpleMessage("Specialties & Focus Areas"),
        "specialtiesHint": MessageLookupByLibrary.simpleMessage(
            "e.g. Strength, Weight Loss, Technique"),
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
        "sportsAndSpecialties":
            MessageLookupByLibrary.simpleMessage("Sports & Specialties"),
        "sportsSelected": m4,
        "startExploringCoaches":
            MessageLookupByLibrary.simpleMessage("Start Exploring Coaches"),
        "stepAvailability":
            MessageLookupByLibrary.simpleMessage("Weekly Availability"),
        "stepOf": m5,
        "stepPersonalInfo":
            MessageLookupByLibrary.simpleMessage("Personal Info"),
        "stepPricing": MessageLookupByLibrary.simpleMessage("Pricing"),
        "stepPricingAvailability":
            MessageLookupByLibrary.simpleMessage("Pricing & Schedule"),
        "stepProfessionalInfo":
            MessageLookupByLibrary.simpleMessage("Professional Info"),
        "stepReviewSubmit":
            MessageLookupByLibrary.simpleMessage("Review & Submit"),
        "stepVerificationDocs":
            MessageLookupByLibrary.simpleMessage("Verification"),
        "submitApplication":
            MessageLookupByLibrary.simpleMessage("Submit Application"),
        "submittingApplication":
            MessageLookupByLibrary.simpleMessage("Submitting application..."),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "supportingDocument":
            MessageLookupByLibrary.simpleMessage("Supporting Document"),
        "tapToUploadPhoto":
            MessageLookupByLibrary.simpleMessage("Tap to upload photo"),
        "testModeBadge": MessageLookupByLibrary.simpleMessage("Test Mode"),
        "toTime": MessageLookupByLibrary.simpleMessage("To"),
        "traineeDesc": MessageLookupByLibrary.simpleMessage(
            "Find qualified coaches, book training sessions, and reach your goals."),
        "traineeDiscovery":
            MessageLookupByLibrary.simpleMessage("Trainee Discovery"),
        "traineeMarketplacePlaceholder": MessageLookupByLibrary.simpleMessage(
            "Trainee Marketplace Screen (Phase 3)"),
        "traineeSetup": MessageLookupByLibrary.simpleMessage("Trainee Setup"),
        "traineeSetupSubtitle": MessageLookupByLibrary.simpleMessage(
            "Create your trainee profile and start your fitness journey"),
        "unavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
        "underReviewNotice": MessageLookupByLibrary.simpleMessage(
            "Your application is currently locked in read-only mode while under review. You will receive an update once the review is completed."),
        "uploadDocument":
            MessageLookupByLibrary.simpleMessage("Upload Document"),
        "uploadFailed": MessageLookupByLibrary.simpleMessage(
            "Upload failed. Please try again later"),
        "uploading": MessageLookupByLibrary.simpleMessage("Uploading..."),
        "uploadingPhoto":
            MessageLookupByLibrary.simpleMessage("Uploading photo..."),
        "validationAgeRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid age (18 - 80)."),
        "validationAvailabilityRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter your general availability."),
        "validationBioMinLength": MessageLookupByLibrary.simpleMessage(
            "Professional bio must be at least 30 characters."),
        "validationCertRequired": MessageLookupByLibrary.simpleMessage(
            "At least one coaching certificate or credential is required."),
        "validationCheckFields": MessageLookupByLibrary.simpleMessage(
            "Please check the required fields."),
        "validationCityRequired":
            MessageLookupByLibrary.simpleMessage("Please enter your city."),
        "validationCountryRequired":
            MessageLookupByLibrary.simpleMessage("Please enter your country."),
        "validationGenderRequired":
            MessageLookupByLibrary.simpleMessage("Please select your gender."),
        "validationIdRequired": MessageLookupByLibrary.simpleMessage(
            "Government ID or Passport upload is required."),
        "validationLanguageRequired": MessageLookupByLibrary.simpleMessage(
            "Please select at least one language."),
        "validationNameRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter your full name."),
        "validationPhotoRequired": MessageLookupByLibrary.simpleMessage(
            "Please upload a profile photo."),
        "validationRateRequired": MessageLookupByLibrary.simpleMessage(
            "Please specify a valid hourly session rate."),
        "validationSportRequired": MessageLookupByLibrary.simpleMessage(
            "Please select at least one sport."),
        "verificationDocsSubtitle": MessageLookupByLibrary.simpleMessage(
            "Government ID and at least one coaching certificate are mandatory for verification."),
        "verificationDocsTitle": MessageLookupByLibrary.simpleMessage(
            "Upload Verification Documents"),
        "verificationEmailSent": MessageLookupByLibrary.simpleMessage(
            "Verification email sent successfully!"),
        "verificationPendingSubtitle": MessageLookupByLibrary.simpleMessage(
            "Our moderation team is reviewing your profile and credentials."),
        "verificationPendingTitle":
            MessageLookupByLibrary.simpleMessage("Verification in Progress"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "weightLoss": MessageLookupByLibrary.simpleMessage("Weight Loss"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
        "welcomeBackUser": m6,
        "yearsOfExperience": MessageLookupByLibrary.simpleMessage(
            "Years of Coaching Experience"),
        "yourGoal": MessageLookupByLibrary.simpleMessage("Your Goal"),
        "yourLevel": MessageLookupByLibrary.simpleMessage("Your Level"),
        "yourProfile": MessageLookupByLibrary.simpleMessage("Your Profile"),
        "yourSports": MessageLookupByLibrary.simpleMessage("Your Sports")
      };
}
