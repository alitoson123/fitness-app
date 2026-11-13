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

  static String m0(count) => "${count} Active Days";

  static String m1(index) => "Additional Certificate ${index}";

  static String m2(count) => "~${count} sessions";

  static String m3(date, time) =>
      "Sorry, your session on ${date} at ${time} was just booked by someone else. Please pick another time for it.";

  static String m4(coachName) =>
      "Your training request has been sent to Coach ${coachName}. You will be notified once they respond.";

  static String m5(count) =>
      "You already have ${count} requests waiting for this coach. Wait for an answer, or cancel one first.";

  static String m6(age) => "${age} yrs";

  static String m7(index, date, time) =>
      "Coach proposed rescheduling Session #${index} to ${date} at ${time}";

  static String m8(phone) =>
      "For your security, enter the 6-digit code we sent to ${phone} to delete your account.";

  static String m9(count) => "Select all ${count} sessions to continue";

  static String m10(hours, mins) => "Starts in ${hours}h ${mins}m";

  static String m11(mins) => "Starts in ${mins}m";

  static String m12(time) => "Today, ${time}";

  static String m13(time) => "Tomorrow, ${time}";

  static String m14(email) => "Signed in as: ${email}";

  static String m15(count) => "${count} days / week";

  static String m16(day) => "End time must be after start time for ${day}.";

  static String m17(day, duration) =>
      "Working hours for ${day} must be at least ${duration} minutes.";

  static String m18(count) => "${count} yrs exp";

  static String m19(name) => "Good afternoon, ${name}";

  static String m20(name) => "Good evening, ${name}";

  static String m21(name) => "Good morning, ${name}";

  static String m22(count) =>
      "${Intl.plural(count, one: '1 Location', other: '${count} Locations')}";

  static String m23(minutes) => "${minutes} min";

  static String m24(index) => "Modifying Session #${index}";

  static String m25(price) => "\$${price} / month";

  static String m26(completed, total) =>
      "${completed} of ${total} Sessions Completed";

  static String m27(current, total) =>
      "${current} of ${total} Sessions Selected";

  static String m28(date, time) => "Next Session: ${date} at ${time}";

  static String m29(phone) => "Enter the 6-digit code sent to ${phone}";

  static String m30(price) => "\$${price} USD";

  static String m31(name) =>
      "Are you sure you want to decline this request from ${name}?";

  static String m32(seconds) => "Resend code in ${seconds}s";

  static String m33(count) =>
      "${Intl.plural(count, one: '1 file attached', other: '${count} files attached')}";

  static String m34(count) =>
      "${Intl.plural(count, one: '1 year', other: '${count} years')}";

  static String m35(count) => "${count} reviews";

  static String m36(count) =>
      "Select ${count} sessions to complete your monthly plan";

  static String m37(count, total) => "Selected Sessions (${count}/${total})";

  static String m38(days) => "In ${days} days";

  static String m39(hours) => "In ${hours} hrs";

  static String m40(reason) => "Decline reason: ${reason}";

  static String m41(number) => "Session #${number}";

  static String m42(number) => "Session ${number}";

  static String m43(price) => "\$${price} / session";

  static String m44(name) => "Session with ${name}";

  static String m45(completed, total) =>
      "Sessions Progress: ${completed} of ${total} completed";

  static String m46(current, total) => "${current}/${total} Sessions";

  static String m47(count) =>
      "${Intl.plural(count, one: '1 sport selected', other: '${count} sports selected')}";

  static String m48(current, total) => "STEP ${current} OF ${total}";

  static String m49(count) =>
      "${Intl.plural(count, one: '1 upcoming session', other: '${count} upcoming sessions')}";

  static String m50(count) =>
      "${Intl.plural(count, one: '1 past session', other: '${count} past sessions')}";

  static String m51(count) =>
      "${Intl.plural(count, one: '1 pending request', other: '${count} pending requests')}";

  static String m52(days) => "${days}d ago";

  static String m53(hours) => "${hours}h ago";

  static String m54(minutes) => "${minutes}m ago";

  static String m55(hours) => "${hours} hrs available";

  static String m56(index, date, time) =>
      "Trainee proposed rescheduling Session #${index} to ${date} at ${time}";

  static String m57(count) =>
      "${Intl.plural(count, one: '1 training day', other: '${count} training days')}";

  static String m58(count) =>
      "${Intl.plural(count, one: 'training day', other: 'training days')}";

  static String m59(name) => "Welcome back, ${name}!";

  static String m60(years) => "${years} Years Experience";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutCoach": MessageLookupByLibrary.simpleMessage("About Coach"),
        "acceptNewTime":
            MessageLookupByLibrary.simpleMessage("Accept New Time"),
        "acceptRequest": MessageLookupByLibrary.simpleMessage("Accept"),
        "accountAndPreferences":
            MessageLookupByLibrary.simpleMessage("Account & Preferences"),
        "accountCreated":
            MessageLookupByLibrary.simpleMessage("Account Created"),
        "accountCreatedMessage": MessageLookupByLibrary.simpleMessage(
            "A verification link has been sent to your email. Please verify before signing in."),
        "accountDeletedSuccess": MessageLookupByLibrary.simpleMessage(
            "Your account has been deleted successfully."),
        "accountSettings":
            MessageLookupByLibrary.simpleMessage("Account Settings"),
        "accountSuspendedMessage": MessageLookupByLibrary.simpleMessage(
            "Your account has been suspended. Please contact support."),
        "activeDaysCount": m0,
        "addLocation": MessageLookupByLibrary.simpleMessage("Add Location"),
        "addPhotoPrompt": MessageLookupByLibrary.simpleMessage(
            "Add a photo so coaches know who you are"),
        "addSport": MessageLookupByLibrary.simpleMessage("Add"),
        "addSupportingDocument":
            MessageLookupByLibrary.simpleMessage("Add Supporting Document"),
        "additionalCertificate": m1,
        "additionalCertificateHint": MessageLookupByLibrary.simpleMessage(
            "Additional certification or accreditation"),
        "additionalNotesOptional":
            MessageLookupByLibrary.simpleMessage("Notes or Goals (Optional)"),
        "adminUseDashboardMessage": MessageLookupByLibrary.simpleMessage(
            "Admin accounts can\'t use the mobile app. Please use the admin dashboard."),
        "advanced": MessageLookupByLibrary.simpleMessage("Advanced"),
        "advancedDesc": MessageLookupByLibrary.simpleMessage(
            "Experienced and want to level up"),
        "age": MessageLookupByLibrary.simpleMessage("Age"),
        "ageHint": MessageLookupByLibrary.simpleMessage("e.g. 28"),
        "allGenders": MessageLookupByLibrary.simpleMessage("All"),
        "allNotificationsMarkedRead": MessageLookupByLibrary.simpleMessage(
            "All notifications marked as read"),
        "allSetSubtitle": MessageLookupByLibrary.simpleMessage(
            "Your trainee profile is ready. Start discovering coaches who match your sport and goals."),
        "allSetTitle": MessageLookupByLibrary.simpleMessage("You\'re all set!"),
        "allSports": MessageLookupByLibrary.simpleMessage("All"),
        "anyExperience": MessageLookupByLibrary.simpleMessage("Any experience"),
        "anyRating": MessageLookupByLibrary.simpleMessage("Any rating"),
        "appName": MessageLookupByLibrary.simpleMessage("CoachHub"),
        "appearanceSetting": MessageLookupByLibrary.simpleMessage("Appearance"),
        "apple": MessageLookupByLibrary.simpleMessage("Apple"),
        "applicationApprovedWelcome": MessageLookupByLibrary.simpleMessage(
            "Application approved! Welcome Coach."),
        "applicationNeedsAttention":
            MessageLookupByLibrary.simpleMessage("Application Needs Attention"),
        "applicationNotFound": MessageLookupByLibrary.simpleMessage(
            "No active application found."),
        "applicationNotFoundMessage": MessageLookupByLibrary.simpleMessage(
            "We couldn\'t find your coach application."),
        "applicationSubmitted":
            MessageLookupByLibrary.simpleMessage("Application Submitted!"),
        "applicationSubmittedDesc": MessageLookupByLibrary.simpleMessage(
            "Your application has been received and is currently under review by our administration team."),
        "applicationSubmittedSuccess": MessageLookupByLibrary.simpleMessage(
            "Application submitted for verification!"),
        "applyFilters": MessageLookupByLibrary.simpleMessage("Apply Filters"),
        "applyToAllActiveDays": MessageLookupByLibrary.simpleMessage(
            "Apply hours to all working days"),
        "approximateSessionsCount": m2,
        "arabicLanguage":
            MessageLookupByLibrary.simpleMessage("العربية (Arabic)"),
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
        "availabilitySavedSuccess": MessageLookupByLibrary.simpleMessage(
            "Your schedule has been updated successfully."),
        "availabilityStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "Set your weekly training schedule and working hours"),
        "availabilitySubtitle": MessageLookupByLibrary.simpleMessage(
            "Set your weekly working days, training hours, and default session duration."),
        "availabilityTitle": MessageLookupByLibrary.simpleMessage(
            "Weekly Availability Overview"),
        "available": MessageLookupByLibrary.simpleMessage("Available"),
        "availableForOnlineTraining": MessageLookupByLibrary.simpleMessage(
            "Available for Online Training"),
        "availableForOnlineTrainingSubtitle":
            MessageLookupByLibrary.simpleMessage(
                "Conduct remote sessions via video call"),
        "avatarUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
            "Profile photo updated successfully"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "backToExplore":
            MessageLookupByLibrary.simpleMessage("Explore More Coaches"),
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
        "bookNewSession":
            MessageLookupByLibrary.simpleMessage("Book New Session"),
        "bookingActionNotAllowed": MessageLookupByLibrary.simpleMessage(
            "This action isn\'t available for this booking anymore. It may have just been changed."),
        "bookingAlreadyStarted": MessageLookupByLibrary.simpleMessage(
            "This booking has already started, so it can\'t be cancelled."),
        "bookingCancelledSuccess":
            MessageLookupByLibrary.simpleMessage("Booking cancelled"),
        "bookingCoachUnavailable": MessageLookupByLibrary.simpleMessage(
            "This coach isn\'t taking bookings right now."),
        "bookingDetailsTitle":
            MessageLookupByLibrary.simpleMessage("Booking Details"),
        "bookingFeatureComingSoon": MessageLookupByLibrary.simpleMessage(
            "Booking request flow opens next!"),
        "bookingInvalidRequest": MessageLookupByLibrary.simpleMessage(
            "Something in this request isn\'t valid. Please check it and try again."),
        "bookingLocationNotOffered": MessageLookupByLibrary.simpleMessage(
            "This coach no longer trains at this place. Please choose another option."),
        "bookingMarkedCompleted":
            MessageLookupByLibrary.simpleMessage("Session marked as completed"),
        "bookingMonthlyNotOffered": MessageLookupByLibrary.simpleMessage(
            "This coach doesn\'t offer monthly packages."),
        "bookingNotAllowedForAccount": MessageLookupByLibrary.simpleMessage(
            "Only trainee accounts can book sessions."),
        "bookingNotFoundMessage": MessageLookupByLibrary.simpleMessage(
            "This booking no longer exists."),
        "bookingNotesPlaceholder": MessageLookupByLibrary.simpleMessage(
            "Describe your fitness goals, past injuries, or requests..."),
        "bookingOutsideHours": MessageLookupByLibrary.simpleMessage(
            "This time is outside the coach\'s working hours. Please pick another time."),
        "bookingOverview":
            MessageLookupByLibrary.simpleMessage("Booking Overview"),
        "bookingRequestTitle":
            MessageLookupByLibrary.simpleMessage("Request Training Session"),
        "bookingSlotTaken": MessageLookupByLibrary.simpleMessage(
            "Sorry, this time was just booked by someone else. Please pick another time."),
        "bookingSlotTakenMonthly": m3,
        "bookingSportNotOffered": MessageLookupByLibrary.simpleMessage(
            "This coach no longer offers this sport."),
        "bookingSuccessDescription": m4,
        "bookingSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Request Sent Successfully!"),
        "bookingSummaryTitle":
            MessageLookupByLibrary.simpleMessage("Booking Summary"),
        "bookingTimeInPast": MessageLookupByLibrary.simpleMessage(
            "This time has already passed. Please pick another time."),
        "bookingTooFarAhead": MessageLookupByLibrary.simpleMessage(
            "You can only book up to a month ahead."),
        "bookingTooManyRequests": m5,
        "bookingTypeLabel":
            MessageLookupByLibrary.simpleMessage("Booking Type"),
        "callClient": MessageLookupByLibrary.simpleMessage("Call"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelBookingAction":
            MessageLookupByLibrary.simpleMessage("Cancel booking"),
        "cancelBookingMessage": MessageLookupByLibrary.simpleMessage(
            "Your coach will be notified and the time will be freed for others. This can\'t be undone."),
        "cancelBookingReasonHint":
            MessageLookupByLibrary.simpleMessage("Reason (optional)"),
        "cancelBookingTitle":
            MessageLookupByLibrary.simpleMessage("Cancel this booking?"),
        "cancellationReasonTitle":
            MessageLookupByLibrary.simpleMessage("Cancellation Reason"),
        "cancelledAccountDeletedReason": MessageLookupByLibrary.simpleMessage(
            "Cancelled automatically because the other account was deleted."),
        "certRequired": MessageLookupByLibrary.simpleMessage(
            "Please upload at least one coaching certificate or degree"),
        "certifications":
            MessageLookupByLibrary.simpleMessage("Certifications"),
        "changePhoto": MessageLookupByLibrary.simpleMessage("Change Photo"),
        "chatClient": MessageLookupByLibrary.simpleMessage("Message"),
        "checkStatusAgain":
            MessageLookupByLibrary.simpleMessage("Refresh Status"),
        "chooseAccountType":
            MessageLookupByLibrary.simpleMessage("Choose Account Type"),
        "chooseDocumentSource":
            MessageLookupByLibrary.simpleMessage("Choose Document Source"),
        "chooseFromGallery":
            MessageLookupByLibrary.simpleMessage("Choose from Gallery"),
        "choosePhotoSource":
            MessageLookupByLibrary.simpleMessage("Choose Photo Source"),
        "chooseTrainingLocation": MessageLookupByLibrary.simpleMessage(
            "Select Training Delivery / Location"),
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
        "clearAllSessions": MessageLookupByLibrary.simpleMessage("Clear All"),
        "clearDraft": MessageLookupByLibrary.simpleMessage("Clear Draft"),
        "clearFilters": MessageLookupByLibrary.simpleMessage("Clear Filters"),
        "clientInfo":
            MessageLookupByLibrary.simpleMessage("Client Information"),
        "clientNotesTitle":
            MessageLookupByLibrary.simpleMessage("Client Notes"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "coachAgeYears": m6,
        "coachBookingsTitle": MessageLookupByLibrary.simpleMessage("Bookings"),
        "coachDashboard":
            MessageLookupByLibrary.simpleMessage("Coach Dashboard"),
        "coachDashboardPlaceholder": MessageLookupByLibrary.simpleMessage(
            "Coach Onboarding & Dashboard (Phase 3)"),
        "coachDashboardSubtitle": MessageLookupByLibrary.simpleMessage(
            "Manage your schedule, availability, and training sessions."),
        "coachDesc": MessageLookupByLibrary.simpleMessage(
            "Offer your sports training services, manage requests, and grow your clients."),
        "coachGender": MessageLookupByLibrary.simpleMessage("Coach Gender"),
        "coachHasNoAvailability": MessageLookupByLibrary.simpleMessage(
            "Coach has no scheduled availability at this time."),
        "coachInfo": MessageLookupByLibrary.simpleMessage("Coach Information"),
        "coachNavAvailability":
            MessageLookupByLibrary.simpleMessage("Availability"),
        "coachNavBookings": MessageLookupByLibrary.simpleMessage("Bookings"),
        "coachNavDashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "coachNavProfile": MessageLookupByLibrary.simpleMessage("Profile"),
        "coachNoLongerAvailable": MessageLookupByLibrary.simpleMessage(
            "This coach is no longer available."),
        "coachPhotoRequired":
            MessageLookupByLibrary.simpleMessage("Profile photo is required"),
        "coachPricingCardTitle":
            MessageLookupByLibrary.simpleMessage("Training Rates (USD)"),
        "coachProfileDetails":
            MessageLookupByLibrary.simpleMessage("Coach Profile"),
        "coachProfileTitle": MessageLookupByLibrary.simpleMessage("My Profile"),
        "coachProposedMonthlyReschedule": m7,
        "coachProposedNewTime": MessageLookupByLibrary.simpleMessage(
            "Coach requested a new session time"),
        "coachReadySubtitle": MessageLookupByLibrary.simpleMessage(
            "Ready for your upcoming training sessions?"),
        "coachReasonLabel":
            MessageLookupByLibrary.simpleMessage("Coach\'s Note"),
        "coachSetupSubtitle": MessageLookupByLibrary.simpleMessage(
            "Create your professional coach profile and submit verification"),
        "coachSetupTitle":
            MessageLookupByLibrary.simpleMessage("Coach Application"),
        "coachSuspendedNotice": MessageLookupByLibrary.simpleMessage(
            "Access to coach features has been restricted. If you believe this is an error or need more information, please contact our support team."),
        "coachSuspendedSubtitle": MessageLookupByLibrary.simpleMessage(
            "Your coach account has been suspended by administration."),
        "coachSuspendedTitle":
            MessageLookupByLibrary.simpleMessage("Account Suspended"),
        "coachingCertificates": MessageLookupByLibrary.simpleMessage(
            "Coaching Certificate or Degree"),
        "coachingCertificatesHint": MessageLookupByLibrary.simpleMessage(
            "Upload coaching certification, diploma, or sports degree"),
        "codeSentSuccess": MessageLookupByLibrary.simpleMessage(
            "Verification code sent successfully!"),
        "competitionPrep":
            MessageLookupByLibrary.simpleMessage("Competition Prep"),
        "completeProfile":
            MessageLookupByLibrary.simpleMessage("Complete Profile"),
        "completeYourProfile":
            MessageLookupByLibrary.simpleMessage("Complete Your Profile"),
        "completedOnThisDay":
            MessageLookupByLibrary.simpleMessage("Completed on this day"),
        "confirmAndSendRequest":
            MessageLookupByLibrary.simpleMessage("Confirm & Send Request"),
        "confirmDecline":
            MessageLookupByLibrary.simpleMessage("Confirm Decline"),
        "confirmDeletionMessage": m8,
        "confirmDeletionTitle":
            MessageLookupByLibrary.simpleMessage("Confirm it\'s you"),
        "confirmSessionsCountPrompt": m9,
        "confirmSignOutMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to sign out from your coach account?"),
        "confirmSignOutTitle":
            MessageLookupByLibrary.simpleMessage("Sign Out?"),
        "confirmSignOutTraineeMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to sign out of your account?"),
        "confirmedSessionsTab":
            MessageLookupByLibrary.simpleMessage("Confirmed"),
        "connectionErrorMessage": MessageLookupByLibrary.simpleMessage(
            "We couldn\'t connect. Check your internet connection and try again."),
        "contactSupport":
            MessageLookupByLibrary.simpleMessage("Contact Support"),
        "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
        "copyEmail": MessageLookupByLibrary.simpleMessage("Copy Email"),
        "countdownHoursMins": m10,
        "countdownMins": m11,
        "countdownToday": m12,
        "countdownTomorrow": m13,
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
        "credentialsAndQualifications":
            MessageLookupByLibrary.simpleMessage("Credentials & Experience"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "currencySAR": MessageLookupByLibrary.simpleMessage("SAR / hr"),
        "currentUserInfo": m14,
        "customWorkoutPlan":
            MessageLookupByLibrary.simpleMessage("Customized fitness guidance"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "dayAvailable": MessageLookupByLibrary.simpleMessage("Available"),
        "dayFri": MessageLookupByLibrary.simpleMessage("Fri"),
        "dayFriday": MessageLookupByLibrary.simpleMessage("Friday"),
        "dayMon": MessageLookupByLibrary.simpleMessage("Mon"),
        "dayMonday": MessageLookupByLibrary.simpleMessage("Monday"),
        "daySat": MessageLookupByLibrary.simpleMessage("Sat"),
        "daySaturday": MessageLookupByLibrary.simpleMessage("Saturday"),
        "dayStatusAvailable":
            MessageLookupByLibrary.simpleMessage("Available for bookings"),
        "dayStatusOff": MessageLookupByLibrary.simpleMessage("Day off"),
        "daySun": MessageLookupByLibrary.simpleMessage("Sun"),
        "daySunday": MessageLookupByLibrary.simpleMessage("Sunday"),
        "dayThu": MessageLookupByLibrary.simpleMessage("Thu"),
        "dayThursday": MessageLookupByLibrary.simpleMessage("Thursday"),
        "dayTue": MessageLookupByLibrary.simpleMessage("Tue"),
        "dayTuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "dayUnavailable": MessageLookupByLibrary.simpleMessage("Off"),
        "dayWed": MessageLookupByLibrary.simpleMessage("Wed"),
        "dayWednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
        "daysPerWeekCount": m15,
        "declineConfirmMessage": MessageLookupByLibrary.simpleMessage(
            "If you decline, the booking will remain at its original scheduled time and will not be cancelled. Proceed?"),
        "declineConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Decline Proposed Time?"),
        "declineReasonHint": MessageLookupByLibrary.simpleMessage(
            "e.g. Schedule conflict, time not suitable..."),
        "declineReasonLabel": MessageLookupByLibrary.simpleMessage(
            "Reason for declining (optional)"),
        "declineReschedule":
            MessageLookupByLibrary.simpleMessage("Decline Proposed Time"),
        "declinedReasonTitle":
            MessageLookupByLibrary.simpleMessage("Decline Reason"),
        "defaultCoachBio": MessageLookupByLibrary.simpleMessage(
            "Certified professional coach dedicated to helping you achieve your personal fitness and performance goals."),
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
        "didNotReceiveCode":
            MessageLookupByLibrary.simpleMessage("Didn\'t receive the code?"),
        "directSupport":
            MessageLookupByLibrary.simpleMessage("Direct scheduling & support"),
        "documentUploadedSuccess": MessageLookupByLibrary.simpleMessage(
            "Document uploaded successfully"),
        "draftRestored": MessageLookupByLibrary.simpleMessage(
            "In-progress application draft restored."),
        "durationMonthsLabel": MessageLookupByLibrary.simpleMessage("Duration"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editAndResubmit":
            MessageLookupByLibrary.simpleMessage("Edit & Resubmit"),
        "editCoachProfile":
            MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "editFitnessAction": MessageLookupByLibrary.simpleMessage("Edit Goals"),
        "editNumber": MessageLookupByLibrary.simpleMessage("Edit"),
        "editPricingAction":
            MessageLookupByLibrary.simpleMessage("Edit Pricing"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "editSportLocations": MessageLookupByLibrary.simpleMessage(
            "Edit Sport Locations & Delivery"),
        "egypt": MessageLookupByLibrary.simpleMessage("Egypt"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "emailCopied":
            MessageLookupByLibrary.simpleMessage("Email copied to clipboard"),
        "emailHint": MessageLookupByLibrary.simpleMessage("name@example.com"),
        "emailVerificationMessage": MessageLookupByLibrary.simpleMessage(
            "Please verify your email address to continue."),
        "emailVerificationRequired":
            MessageLookupByLibrary.simpleMessage("Email Verification Required"),
        "emptyFilterNotificationsDesc": MessageLookupByLibrary.simpleMessage(
            "No notifications match the selected filter."),
        "emptyNotificationsDesc": MessageLookupByLibrary.simpleMessage(
            "You\'re all caught up! Updates about your bookings and account will appear here."),
        "emptyNotificationsTitle":
            MessageLookupByLibrary.simpleMessage("No notifications yet"),
        "endTime": MessageLookupByLibrary.simpleMessage("End Time"),
        "englishLanguage": MessageLookupByLibrary.simpleMessage("English"),
        "enterLocationHint": MessageLookupByLibrary.simpleMessage(
            "Enter club, gym, or field name..."),
        "enterOtherSport": MessageLookupByLibrary.simpleMessage(
            "Enter sport name (e.g. Squash)"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "errorInvalidTimeRange": m16,
        "errorLoadingCoachProfile": MessageLookupByLibrary.simpleMessage(
            "Failed to load coach profile. Tap to retry."),
        "errorLoadingCoaches": MessageLookupByLibrary.simpleMessage(
            "Failed to load coaches. Tap to retry."),
        "errorNoWorkingDays": MessageLookupByLibrary.simpleMessage(
            "Please select at least one working day."),
        "errorTimeWindowTooShort": m17,
        "expectedReviewTime": MessageLookupByLibrary.simpleMessage(
            "Expected review: 24 - 48 hours"),
        "experienceYearsCount": m18,
        "fakeCoachDashboardSubtitle": MessageLookupByLibrary.simpleMessage(
            "Welcome Coach! This is a test screen to verify navigation, authentication, and role flows."),
        "fakeCoachDashboardTitle":
            MessageLookupByLibrary.simpleMessage("Coach Dashboard"),
        "fakeTraineeHomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "Welcome Trainee! This is a test screen to verify navigation, authentication, and role flows."),
        "fakeTraineeHomeTitle":
            MessageLookupByLibrary.simpleMessage("Trainee Home"),
        "favoriteSports":
            MessageLookupByLibrary.simpleMessage("Sports & Activities"),
        "female": MessageLookupByLibrary.simpleMessage("Female"),
        "femaleOnly": MessageLookupByLibrary.simpleMessage("Female"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage(
            "File size exceeds 10MB limit"),
        "fileUploaded":
            MessageLookupByLibrary.simpleMessage("Document Selected"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "filterAdmin": MessageLookupByLibrary.simpleMessage("System & Admin"),
        "filterAll": MessageLookupByLibrary.simpleMessage("All"),
        "filterBookings": MessageLookupByLibrary.simpleMessage("Bookings"),
        "filters": MessageLookupByLibrary.simpleMessage("Filters"),
        "fitnessGoal": MessageLookupByLibrary.simpleMessage("Fitness Goal"),
        "fitnessLevel": MessageLookupByLibrary.simpleMessage("Fitness Level"),
        "fitnessOverviewTitle":
            MessageLookupByLibrary.simpleMessage("Fitness Overview"),
        "fitnessProfile":
            MessageLookupByLibrary.simpleMessage("Fitness & Goals"),
        "flexibleSchedule": MessageLookupByLibrary.simpleMessage(
            "Flexible / Coordinated with Coach"),
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
        "greetingAfternoon": m19,
        "greetingEvening": m20,
        "greetingMorning": m21,
        "groupLater": MessageLookupByLibrary.simpleMessage("Upcoming Later"),
        "groupPast": MessageLookupByLibrary.simpleMessage("Past Sessions"),
        "groupThisWeek": MessageLookupByLibrary.simpleMessage("This Week"),
        "groupToday": MessageLookupByLibrary.simpleMessage("Today"),
        "groupTomorrow": MessageLookupByLibrary.simpleMessage("Tomorrow"),
        "helpAndSupport":
            MessageLookupByLibrary.simpleMessage("Help & Support"),
        "helpAndSupportDesc": MessageLookupByLibrary.simpleMessage(
            "Contact our team for inquiries"),
        "hourlyRateHint": MessageLookupByLibrary.simpleMessage("e.g. 150"),
        "hourlyRateRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid hourly rate greater than 0"),
        "hoursAppliedToAllDays": MessageLookupByLibrary.simpleMessage(
            "Hours applied to all working days"),
        "howWillYouUse": MessageLookupByLibrary.simpleMessage(
            "How will you be using CoachHub?"),
        "iAmCoach": MessageLookupByLibrary.simpleMessage("I am a Coach"),
        "iAmTrainee": MessageLookupByLibrary.simpleMessage("I am a Trainee"),
        "idRequired": MessageLookupByLibrary.simpleMessage(
            "Please upload your government ID"),
        "incomingRequestsTab": MessageLookupByLibrary.simpleMessage("Requests"),
        "intermediate": MessageLookupByLibrary.simpleMessage("Intermediate"),
        "intermediateDesc":
            MessageLookupByLibrary.simpleMessage("Some experience"),
        "invalidOtpCode": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid 6-digit code"),
        "invalidPhoneFormat": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid phone number for the selected country"),
        "keepBooking": MessageLookupByLibrary.simpleMessage("Keep booking"),
        "langArabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "langEnglish": MessageLookupByLibrary.simpleMessage("English"),
        "langFrench": MessageLookupByLibrary.simpleMessage("French"),
        "langGerman": MessageLookupByLibrary.simpleMessage("German"),
        "langSpanish": MessageLookupByLibrary.simpleMessage("Spanish"),
        "languageSetting": MessageLookupByLibrary.simpleMessage("Language"),
        "languages": MessageLookupByLibrary.simpleMessage("Languages Spoken"),
        "lebanon": MessageLookupByLibrary.simpleMessage("Lebanon"),
        "levelSubtitle": MessageLookupByLibrary.simpleMessage(
            "This helps us match you with the right coaches"),
        "lightMode": MessageLookupByLibrary.simpleMessage("Light Mode"),
        "loadProfileError": MessageLookupByLibrary.simpleMessage(
            "Failed to load profile. Tap to retry."),
        "locationsCount": m22,
        "male": MessageLookupByLibrary.simpleMessage("Male"),
        "maleOnly": MessageLookupByLibrary.simpleMessage("Male"),
        "manageAvailability": MessageLookupByLibrary.simpleMessage(
            "Availability & Working Hours"),
        "manageWorkingHours":
            MessageLookupByLibrary.simpleMessage("Manage Availability"),
        "markAllAsRead":
            MessageLookupByLibrary.simpleMessage("Mark all as read"),
        "markAsCompleted":
            MessageLookupByLibrary.simpleMessage("Mark as Completed"),
        "minExperienceYears":
            MessageLookupByLibrary.simpleMessage("Experience"),
        "minimumRating": MessageLookupByLibrary.simpleMessage("Minimum Rating"),
        "minutesDuration": m23,
        "modifyingSession": m24,
        "monthlyPackageType":
            MessageLookupByLibrary.simpleMessage("Monthly Plan"),
        "monthlyPlanSummaryTitle":
            MessageLookupByLibrary.simpleMessage("Monthly Package Summary"),
        "monthlyPriceChip": m25,
        "monthlyPriceUSD": MessageLookupByLibrary.simpleMessage(
            "Monthly Package Price (\$ USD)"),
        "monthlyPriceUSDDesc": MessageLookupByLibrary.simpleMessage(
            "Full Month Training Package in USD"),
        "monthlyPriceUSDHint": MessageLookupByLibrary.simpleMessage("e.g. 200"),
        "monthlyPricingOptionDesc": MessageLookupByLibrary.simpleMessage(
            "Ongoing full-month training plan, tracking & guidance"),
        "monthlyPricingOptionTitle":
            MessageLookupByLibrary.simpleMessage("Monthly Package"),
        "monthlyProgressCompleted": m26,
        "monthlyScheduleNotesHint": MessageLookupByLibrary.simpleMessage(
            "e.g., Evenings around 6 PM, focus on strength building"),
        "monthlyScheduleNotesLabel":
            MessageLookupByLibrary.simpleMessage("Preferred Schedule & Goals"),
        "monthlySessionsProgress": m27,
        "myBookings": MessageLookupByLibrary.simpleMessage("Training Bookings"),
        "nationalIdHint": MessageLookupByLibrary.simpleMessage(
            "Upload photo or PDF of your National ID or Passport"),
        "nationalIdOrPassport":
            MessageLookupByLibrary.simpleMessage("Government ID or Passport"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "nextSessionLabel": m28,
        "nextSessionTitle":
            MessageLookupByLibrary.simpleMessage("Next Upcoming Session"),
        "noAvailabilityListed": MessageLookupByLibrary.simpleMessage(
            "No fixed schedule listed. Discuss upon request."),
        "noAvailableSlotsForDate": MessageLookupByLibrary.simpleMessage(
            "No available slots on this day"),
        "noAvailableSlotsForDay": MessageLookupByLibrary.simpleMessage(
            "No available slots for this day"),
        "noBioProvided":
            MessageLookupByLibrary.simpleMessage("No bio provided yet."),
        "noBookingsFound":
            MessageLookupByLibrary.simpleMessage("No bookings found"),
        "noCertificatesUploaded": MessageLookupByLibrary.simpleMessage(
            "No certificates uploaded yet."),
        "noCoachesFound":
            MessageLookupByLibrary.simpleMessage("No coaches found"),
        "noCoachesFoundDesc": MessageLookupByLibrary.simpleMessage(
            "Try adjusting your search or filters to find available coaches."),
        "noConfirmedSessionsDesc": MessageLookupByLibrary.simpleMessage(
            "Sessions you have accepted will show up here."),
        "noConfirmedSessionsTitle":
            MessageLookupByLibrary.simpleMessage("No Confirmed Sessions"),
        "noDaysSelected":
            MessageLookupByLibrary.simpleMessage("No days selected"),
        "noLocationsOrOnlineWarning": MessageLookupByLibrary.simpleMessage(
            "Please enable online training or add at least one location"),
        "noNotesAvailable": MessageLookupByLibrary.simpleMessage(
            "No additional notes provided"),
        "noPastSessionsDesc": MessageLookupByLibrary.simpleMessage(
            "Completed and declined requests will be archived here."),
        "noPastSessionsTitle":
            MessageLookupByLibrary.simpleMessage("No Past Sessions"),
        "noPendingRequestsDesc": MessageLookupByLibrary.simpleMessage(
            "New trainee booking requests will appear here in real time."),
        "noPendingRequestsPreview": MessageLookupByLibrary.simpleMessage(
            "No pending requests at the moment"),
        "noPendingRequestsTitle":
            MessageLookupByLibrary.simpleMessage("No Pending Requests"),
        "noProfileData": MessageLookupByLibrary.simpleMessage(
            "No profile information found"),
        "noReviewsYet": MessageLookupByLibrary.simpleMessage("New"),
        "noSportsSelected":
            MessageLookupByLibrary.simpleMessage("No sports selected"),
        "noUpcomingSessions":
            MessageLookupByLibrary.simpleMessage("No upcoming sessions"),
        "noUpcomingSessionsDesc": MessageLookupByLibrary.simpleMessage(
            "Set your availability so trainees can book sessions with you."),
        "noUpcomingSessionsTitle":
            MessageLookupByLibrary.simpleMessage("No upcoming sessions"),
        "notOffered": MessageLookupByLibrary.simpleMessage("Not offered"),
        "notSpecified": MessageLookupByLibrary.simpleMessage("Not specified"),
        "notificationCenter":
            MessageLookupByLibrary.simpleMessage("Notification Center"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notification deleted"),
        "notificationsTooltip":
            MessageLookupByLibrary.simpleMessage("Notifications"),
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
        "oneMonthDuration": MessageLookupByLibrary.simpleMessage("1 Month"),
        "oneOnOneTraining":
            MessageLookupByLibrary.simpleMessage("1-on-1 private coaching"),
        "onlineAvailableBadge":
            MessageLookupByLibrary.simpleMessage("Online Available"),
        "onlineCoachingAvailableBadge":
            MessageLookupByLibrary.simpleMessage("Online Coaching Available"),
        "onlineTrainingOption":
            MessageLookupByLibrary.simpleMessage("Online Training"),
        "onlineTrainingOptionSubtitle": MessageLookupByLibrary.simpleMessage(
            "Virtual coaching session via app / video"),
        "orContinueWith":
            MessageLookupByLibrary.simpleMessage("or continue with"),
        "originalTimeLabel":
            MessageLookupByLibrary.simpleMessage("Original Time"),
        "otpIncorrectOrExpired": MessageLookupByLibrary.simpleMessage(
            "The code is incorrect or has expired."),
        "otpVerification":
            MessageLookupByLibrary.simpleMessage("Verification Code"),
        "otpVerificationSubtitle": m29,
        "packageStartDateLabel":
            MessageLookupByLibrary.simpleMessage("Start Date"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "passwordLengthHint":
            MessageLookupByLibrary.simpleMessage("At least 6 characters"),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "pastSessionsTab": MessageLookupByLibrary.simpleMessage("History"),
        "paymentStatusPaid": MessageLookupByLibrary.simpleMessage("Paid"),
        "paymentStatusPending":
            MessageLookupByLibrary.simpleMessage("Payment Pending"),
        "pdfDocument": MessageLookupByLibrary.simpleMessage("PDF Document"),
        "pdfUploaded":
            MessageLookupByLibrary.simpleMessage("PDF Document Selected"),
        "pendingRequests":
            MessageLookupByLibrary.simpleMessage("Pending Requests"),
        "pendingRequestsPreview":
            MessageLookupByLibrary.simpleMessage("Pending Requests"),
        "pendingVerificationBadge":
            MessageLookupByLibrary.simpleMessage("Verification Pending"),
        "perMonthUnit": MessageLookupByLibrary.simpleMessage("/ month"),
        "perSessionUnit": MessageLookupByLibrary.simpleMessage("/ session"),
        "periodDay": MessageLookupByLibrary.simpleMessage("Day"),
        "periodMonth": MessageLookupByLibrary.simpleMessage("Month"),
        "periodYear": MessageLookupByLibrary.simpleMessage("Year"),
        "personalInfo":
            MessageLookupByLibrary.simpleMessage("Personal Information"),
        "phoneAuthFailed": MessageLookupByLibrary.simpleMessage(
            "Verification failed. Please try again."),
        "phoneHint": MessageLookupByLibrary.simpleMessage("+966 50 123 4567"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "phoneSignInSubtitle": MessageLookupByLibrary.simpleMessage(
            "Enter your mobile number to receive a verification code"),
        "photoUploadFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to upload photo. Please try again."),
        "photoUploadedSuccess":
            MessageLookupByLibrary.simpleMessage("Photo uploaded successfully"),
        "physicalLocations":
            MessageLookupByLibrary.simpleMessage("Physical Locations & Clubs"),
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
        "pleaseSelectStartDate":
            MessageLookupByLibrary.simpleMessage("Please select a start date"),
        "pleaseSelectTimeSlot": MessageLookupByLibrary.simpleMessage(
            "Please select an available time slot"),
        "preferNotToSay":
            MessageLookupByLibrary.simpleMessage("Prefer not to say"),
        "pricePerSession":
            MessageLookupByLibrary.simpleMessage("Price per Session"),
        "pricePerSessionHint": MessageLookupByLibrary.simpleMessage("e.g. 150"),
        "priceRange": MessageLookupByLibrary.simpleMessage("Price Range"),
        "priceUsdFormat": m30,
        "pricingStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "Set your session price and preferred currency"),
        "pricingTipText":
            MessageLookupByLibrary.simpleMessage("Set a price per session."),
        "pricingTitle":
            MessageLookupByLibrary.simpleMessage("Hourly Training Rate"),
        "pricingUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
            "Pricing updated successfully"),
        "profileUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
            "Profile updated successfully"),
        "proposedTimeLabel":
            MessageLookupByLibrary.simpleMessage("Proposed Time"),
        "pushNotifications":
            MessageLookupByLibrary.simpleMessage("Push Notifications"),
        "pushNotificationsDesc": MessageLookupByLibrary.simpleMessage(
            "Receive booking and message alerts"),
        "quickActionAvailability":
            MessageLookupByLibrary.simpleMessage("Manage Availability"),
        "quickActionAvailabilityDesc":
            MessageLookupByLibrary.simpleMessage("Set working days & hours"),
        "quickActionBookings":
            MessageLookupByLibrary.simpleMessage("View All Bookings"),
        "quickActionBookingsDesc": MessageLookupByLibrary.simpleMessage(
            "Requests, confirmed & history"),
        "quickActions": MessageLookupByLibrary.simpleMessage("Quick Actions"),
        "quickAvailabilityTemplates": MessageLookupByLibrary.simpleMessage(
            "Quick Availability Templates"),
        "quickEditPricingTitle":
            MessageLookupByLibrary.simpleMessage("Update Training Rates"),
        "rejectReasonFullyBooked":
            MessageLookupByLibrary.simpleMessage("Fully booked"),
        "rejectReasonOther":
            MessageLookupByLibrary.simpleMessage("Other reason"),
        "rejectReasonOutsideHours":
            MessageLookupByLibrary.simpleMessage("Outside working hours"),
        "rejectReasonScheduleConflict":
            MessageLookupByLibrary.simpleMessage("Schedule conflict"),
        "rejectRequest": MessageLookupByLibrary.simpleMessage("Decline"),
        "rejectRequestDialogDesc": m31,
        "rejectRequestDialogTitle":
            MessageLookupByLibrary.simpleMessage("Decline Request"),
        "rejectionNotesHint": MessageLookupByLibrary.simpleMessage(
            "Add details or explanation (optional)..."),
        "rejectionNotesRequiredHint": MessageLookupByLibrary.simpleMessage(
            "Please specify the reason..."),
        "rejectionReasonFallback": MessageLookupByLibrary.simpleMessage(
            "Your application needs some changes. Please review it and submit again."),
        "rejectionReasonHint": MessageLookupByLibrary.simpleMessage(
            "e.g., Schedule conflict, out of gym, etc."),
        "rejectionReasonLabel":
            MessageLookupByLibrary.simpleMessage("Moderation Feedback:"),
        "rejectionReasonOptional": MessageLookupByLibrary.simpleMessage(
            "Reason for declining (optional)"),
        "rejectionReasonTitle":
            MessageLookupByLibrary.simpleMessage("Rejection Reason"),
        "removeDocument":
            MessageLookupByLibrary.simpleMessage("Remove Document"),
        "removePhoto": MessageLookupByLibrary.simpleMessage("Remove Photo"),
        "replaceFile": MessageLookupByLibrary.simpleMessage("Replace File"),
        "requestAcceptedSuccess": MessageLookupByLibrary.simpleMessage(
            "Training request confirmed successfully!"),
        "requestExpiredMessage": MessageLookupByLibrary.simpleMessage(
            "This request expired: its time passed before the coach answered."),
        "requestRejectedSuccess":
            MessageLookupByLibrary.simpleMessage("Training request declined."),
        "requestTraining":
            MessageLookupByLibrary.simpleMessage("Request Training Session"),
        "requiredBadge": MessageLookupByLibrary.simpleMessage("Required"),
        "rescheduleAcceptedSuccess": MessageLookupByLibrary.simpleMessage(
            "Session successfully rescheduled!"),
        "rescheduleAction": MessageLookupByLibrary.simpleMessage("Reschedule"),
        "rescheduleDeclinedMessage": MessageLookupByLibrary.simpleMessage(
            "Proposed time declined. The booking remains at its original scheduled time."),
        "reschedulePendingBadge":
            MessageLookupByLibrary.simpleMessage("Reschedule Awaiting Client"),
        "reschedulePendingCoachBadge":
            MessageLookupByLibrary.simpleMessage("Reschedule Awaiting Coach"),
        "rescheduleReasonHint": MessageLookupByLibrary.simpleMessage(
            "Explain why you need to reschedule (emergency, illness...)"),
        "rescheduleReasonLabel":
            MessageLookupByLibrary.simpleMessage("Reason for Rescheduling"),
        "rescheduleReasonRequired": MessageLookupByLibrary.simpleMessage(
            "Please provide a reason for the reschedule"),
        "rescheduleRequestedBadge":
            MessageLookupByLibrary.simpleMessage("Reschedule Requested"),
        "rescheduleRequestedCoachSuccess": MessageLookupByLibrary.simpleMessage(
            "Reschedule request sent to coach"),
        "rescheduleRequestedSuccess": MessageLookupByLibrary.simpleMessage(
            "Reschedule request sent to client"),
        "rescheduleSession":
            MessageLookupByLibrary.simpleMessage("Reschedule Session"),
        "rescheduleThisSession":
            MessageLookupByLibrary.simpleMessage("Reschedule This Session"),
        "resend": MessageLookupByLibrary.simpleMessage("Resend"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend Code"),
        "resendCodeIn": m32,
        "resendEmail": MessageLookupByLibrary.simpleMessage("Resend Email"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
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
        "reviewFilesAttached": m33,
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
        "reviewYearsCount": m34,
        "reviewsCount": m35,
        "role": MessageLookupByLibrary.simpleMessage("Role"),
        "saveAvailability":
            MessageLookupByLibrary.simpleMessage("Save Schedule"),
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
        "savingAvailability": MessageLookupByLibrary.simpleMessage("Saving..."),
        "scheduleAndAvailability": MessageLookupByLibrary.simpleMessage(
            "Weekly Schedule & Availability"),
        "searchCoaches":
            MessageLookupByLibrary.simpleMessage("Search coaches or sports..."),
        "selectCity": MessageLookupByLibrary.simpleMessage("Select City"),
        "selectCountry": MessageLookupByLibrary.simpleMessage("Select Country"),
        "selectCountryFirst": MessageLookupByLibrary.simpleMessage(
            "Please select a country first"),
        "selectCurrency":
            MessageLookupByLibrary.simpleMessage("Select Currency"),
        "selectDaysAndHours": MessageLookupByLibrary.simpleMessage(
            "Select the days and hours you\'re available for training."),
        "selectDeliveryLocationPrompt": MessageLookupByLibrary.simpleMessage(
            "Please select where you would like this training to take place."),
        "selectFitnessGoal":
            MessageLookupByLibrary.simpleMessage("Select Fitness Goal"),
        "selectFitnessLevel":
            MessageLookupByLibrary.simpleMessage("Select Fitness Level"),
        "selectLanguages":
            MessageLookupByLibrary.simpleMessage("Select Languages"),
        "selectPackageStartDate":
            MessageLookupByLibrary.simpleMessage("Select Start Date"),
        "selectRejectionReasonLabel":
            MessageLookupByLibrary.simpleMessage("Select a reason:"),
        "selectRequiredSessionsPrompt": m36,
        "selectSessionToReschedule": MessageLookupByLibrary.simpleMessage(
            "Select session to reschedule"),
        "selectSportsPrompt":
            MessageLookupByLibrary.simpleMessage("Select Sports"),
        "selectSportsSubtitle": MessageLookupByLibrary.simpleMessage(
            "Select one or more sports you want to train in"),
        "selectSportsYouCoach":
            MessageLookupByLibrary.simpleMessage("Select the sports you coach"),
        "selectTrainingDate":
            MessageLookupByLibrary.simpleMessage("Select Date"),
        "selectTrainingSport":
            MessageLookupByLibrary.simpleMessage("Select Sport"),
        "selectTrainingTime":
            MessageLookupByLibrary.simpleMessage("Select Time Slot"),
        "selectedDateLabel": MessageLookupByLibrary.simpleMessage("Date"),
        "selectedSessionsListTitle": m37,
        "selectedSportLabel": MessageLookupByLibrary.simpleMessage("Sport"),
        "selectedTimeLabel": MessageLookupByLibrary.simpleMessage("Time"),
        "sendOtp":
            MessageLookupByLibrary.simpleMessage("Send Verification Code"),
        "sendRescheduleRequest":
            MessageLookupByLibrary.simpleMessage("Send Reschedule Request"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("Send Reset Link"),
        "sendingCode": MessageLookupByLibrary.simpleMessage("Sending code..."),
        "sessionCompleted":
            MessageLookupByLibrary.simpleMessage("Session Completed"),
        "sessionCountdownDays": m38,
        "sessionCountdownHours": m39,
        "sessionCountdownToday": MessageLookupByLibrary.simpleMessage("Today"),
        "sessionDeclineReason": m40,
        "sessionDuration":
            MessageLookupByLibrary.simpleMessage("Session Duration"),
        "sessionHistory":
            MessageLookupByLibrary.simpleMessage("Session History"),
        "sessionIndex": m41,
        "sessionNotFoundMessage": MessageLookupByLibrary.simpleMessage(
            "Your session has ended. Please sign in again."),
        "sessionNotStartedYet": MessageLookupByLibrary.simpleMessage(
            "You can mark it as completed once the session time has started."),
        "sessionNumberLabel": m42,
        "sessionPassed": MessageLookupByLibrary.simpleMessage("Passed"),
        "sessionPriceChip": m43,
        "sessionPricing":
            MessageLookupByLibrary.simpleMessage("Session Pricing"),
        "sessionPricingOptionDesc": MessageLookupByLibrary.simpleMessage(
            "1-on-1 scheduled live workout with tailored coaching"),
        "sessionPricingOptionTitle":
            MessageLookupByLibrary.simpleMessage("Single Session"),
        "sessionWith": m44,
        "sessionsProgress": m45,
        "sessionsSchedule":
            MessageLookupByLibrary.simpleMessage("Sessions Schedule"),
        "sessionsSelectedCount": m46,
        "setAvailabilityButton":
            MessageLookupByLibrary.simpleMessage("Set Availability"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "Sign in to access your sports platform"),
        "signInWithPhone":
            MessageLookupByLibrary.simpleMessage("Sign In with Phone"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "Join CoachHub to get started today"),
        "singleSessionPlan":
            MessageLookupByLibrary.simpleMessage("Single Session"),
        "singleSessionPriceUSD": MessageLookupByLibrary.simpleMessage(
            "Single Session Price (\$ USD)"),
        "singleSessionPriceUSDDesc":
            MessageLookupByLibrary.simpleMessage("Single Session Rate in USD"),
        "singleSessionPriceUSDHint":
            MessageLookupByLibrary.simpleMessage("e.g. 50"),
        "singleSessionType":
            MessageLookupByLibrary.simpleMessage("Single Session"),
        "skillDevelopment":
            MessageLookupByLibrary.simpleMessage("Skill Development"),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "skipForNow": MessageLookupByLibrary.simpleMessage("Skip for now"),
        "slotsLoadFailed": MessageLookupByLibrary.simpleMessage(
            "Couldn\'t load the available times."),
        "smsSendFailed": MessageLookupByLibrary.simpleMessage(
            "We couldn\'t send the code. Please try again."),
        "sortBy": MessageLookupByLibrary.simpleMessage("Sort By"),
        "sortExperienceHighToLow":
            MessageLookupByLibrary.simpleMessage("Most Experienced"),
        "sortPriceHighToLow":
            MessageLookupByLibrary.simpleMessage("Price: High to Low"),
        "sortPriceLowToHigh":
            MessageLookupByLibrary.simpleMessage("Price: Low to High"),
        "sortRatingHighToLow":
            MessageLookupByLibrary.simpleMessage("Rating: Highest First"),
        "sortRecommended": MessageLookupByLibrary.simpleMessage("Recommended"),
        "specialties": MessageLookupByLibrary.simpleMessage("Specialties"),
        "specialties1":
            MessageLookupByLibrary.simpleMessage("Specialties & Focus Areas"),
        "specialtiesHint": MessageLookupByLibrary.simpleMessage(
            "e.g. Strength, Weight Loss, Technique"),
        "specialtiesLabel": MessageLookupByLibrary.simpleMessage("Specialties"),
        "splashSubtitle": MessageLookupByLibrary.simpleMessage(
            "Find Your Perfect Sports Coach"),
        "spokenLanguages":
            MessageLookupByLibrary.simpleMessage("Spoken Languages"),
        "sportBadminton": MessageLookupByLibrary.simpleMessage("Badminton"),
        "sportBasketball": MessageLookupByLibrary.simpleMessage("Basketball"),
        "sportBoxing": MessageLookupByLibrary.simpleMessage("Boxing"),
        "sportCrossFit": MessageLookupByLibrary.simpleMessage("CrossFit"),
        "sportCycling": MessageLookupByLibrary.simpleMessage("Cycling"),
        "sportDeliveryModeSubtitle": MessageLookupByLibrary.simpleMessage(
            "Configure physical venues or virtual coaching for each sport"),
        "sportDeliveryModeTitle":
            MessageLookupByLibrary.simpleMessage("Training Mode & Locations"),
        "sportFootball": MessageLookupByLibrary.simpleMessage("Football"),
        "sportGym": MessageLookupByLibrary.simpleMessage("Gym"),
        "sportHandball": MessageLookupByLibrary.simpleMessage("Handball"),
        "sportMartialArts":
            MessageLookupByLibrary.simpleMessage("Martial Arts"),
        "sportOther": MessageLookupByLibrary.simpleMessage("Other"),
        "sportPadel": MessageLookupByLibrary.simpleMessage("Padel"),
        "sportRunning": MessageLookupByLibrary.simpleMessage("Running"),
        "sportSwimming": MessageLookupByLibrary.simpleMessage("Swimming"),
        "sportTableTennis":
            MessageLookupByLibrary.simpleMessage("Table Tennis"),
        "sportTennis": MessageLookupByLibrary.simpleMessage("Tennis"),
        "sportVolleyball": MessageLookupByLibrary.simpleMessage("Volleyball"),
        "sportsAndLocationsTitle":
            MessageLookupByLibrary.simpleMessage("Sports & Training Locations"),
        "sportsAndSpecialties":
            MessageLookupByLibrary.simpleMessage("Sports & Specialties"),
        "sportsSelected": m47,
        "startExploringCoaches":
            MessageLookupByLibrary.simpleMessage("Start Exploring Coaches"),
        "startTime": MessageLookupByLibrary.simpleMessage("Start Time"),
        "statHistory": MessageLookupByLibrary.simpleMessage("History"),
        "statPending": MessageLookupByLibrary.simpleMessage("Pending"),
        "statUpcoming": MessageLookupByLibrary.simpleMessage("Upcoming"),
        "statusCancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
        "statusCompleted": MessageLookupByLibrary.simpleMessage("Completed"),
        "statusConfirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
        "statusDeclined": MessageLookupByLibrary.simpleMessage("Declined"),
        "statusExpired": MessageLookupByLibrary.simpleMessage("Expired"),
        "statusReschedulePending":
            MessageLookupByLibrary.simpleMessage("Reschedule Pending"),
        "statusUpcoming": MessageLookupByLibrary.simpleMessage("Upcoming"),
        "stepAvailability":
            MessageLookupByLibrary.simpleMessage("Weekly Availability"),
        "stepOf": m48,
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
        "submittingBookingRequest":
            MessageLookupByLibrary.simpleMessage("Sending request..."),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "summaryConfirmedSessions": m49,
        "summaryPastSessions": m50,
        "summaryPendingRequests": m51,
        "supportEmail":
            MessageLookupByLibrary.simpleMessage("alitoson1234567@gmail.com"),
        "supportModalDesc": MessageLookupByLibrary.simpleMessage(
            "Our support team is available to assist you with your account and application inquiries."),
        "supportModalTitle":
            MessageLookupByLibrary.simpleMessage("Support Assistance"),
        "supportingDocument":
            MessageLookupByLibrary.simpleMessage("Supporting Document"),
        "suspendedStatusBadge":
            MessageLookupByLibrary.simpleMessage("Suspended"),
        "takePhoto": MessageLookupByLibrary.simpleMessage("Take Photo"),
        "tapToHideDetails":
            MessageLookupByLibrary.simpleMessage("Tap to hide details"),
        "tapToUploadPhoto":
            MessageLookupByLibrary.simpleMessage("Tap to upload photo"),
        "tapToViewDetails":
            MessageLookupByLibrary.simpleMessage("Tap to view coach\'s note"),
        "testModeBadge": MessageLookupByLibrary.simpleMessage("Test Mode"),
        "thisMonthEarnings":
            MessageLookupByLibrary.simpleMessage("This Month\'s Earnings"),
        "thisWeekSchedule":
            MessageLookupByLibrary.simpleMessage("This Week\'s Schedule"),
        "timeDaysAgo": m52,
        "timeHoursAgo": m53,
        "timeJustNow": MessageLookupByLibrary.simpleMessage("Just now"),
        "timeMinutesAgo": m54,
        "timeSlots": MessageLookupByLibrary.simpleMessage("Working Hours"),
        "toTime": MessageLookupByLibrary.simpleMessage("To"),
        "tooManyAttemptsMessage": MessageLookupByLibrary.simpleMessage(
            "Too many attempts. Please try again later."),
        "totalDurationLabel": m55,
        "totalMonthlyPrice":
            MessageLookupByLibrary.simpleMessage("Monthly Price"),
        "totalSessionPrice":
            MessageLookupByLibrary.simpleMessage("Session Price"),
        "trainee": MessageLookupByLibrary.simpleMessage("Trainee"),
        "traineeActiveBadge":
            MessageLookupByLibrary.simpleMessage("Active Trainee"),
        "traineeDesc": MessageLookupByLibrary.simpleMessage(
            "Find qualified coaches, book training sessions, and reach your goals."),
        "traineeDiscovery":
            MessageLookupByLibrary.simpleMessage("Trainee Discovery"),
        "traineeMarketplacePlaceholder": MessageLookupByLibrary.simpleMessage(
            "Trainee Marketplace Screen (Phase 3)"),
        "traineeNavDiscovery":
            MessageLookupByLibrary.simpleMessage("Discovery"),
        "traineeNavProfile": MessageLookupByLibrary.simpleMessage("Profile"),
        "traineeNotes": MessageLookupByLibrary.simpleMessage("Trainee Notes"),
        "traineeProfileTitle":
            MessageLookupByLibrary.simpleMessage("My Profile"),
        "traineeProposedMonthlyReschedule": m56,
        "traineeProposedNewTime": MessageLookupByLibrary.simpleMessage(
            "Trainee requested a new session time"),
        "traineeReasonLabel":
            MessageLookupByLibrary.simpleMessage("Trainee\'s Note"),
        "traineeSetup": MessageLookupByLibrary.simpleMessage("Trainee Setup"),
        "traineeSetupSubtitle": MessageLookupByLibrary.simpleMessage(
            "Create your trainee profile and start your fitness journey"),
        "trainingActivityTitle":
            MessageLookupByLibrary.simpleMessage("Training Activity"),
        "trainingDaysCount": m57,
        "trainingDaysUnit": m58,
        "trainingInsightsEmpty": MessageLookupByLibrary.simpleMessage(
            "No completed training sessions for this period"),
        "trainingInsightsEmptySubtitle": MessageLookupByLibrary.simpleMessage(
            "Completed workouts will appear here"),
        "trainingInsightsTitle":
            MessageLookupByLibrary.simpleMessage("Training Insights"),
        "trainingLocationLabel":
            MessageLookupByLibrary.simpleMessage("Training Location"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Try Again"),
        "unavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
        "underReviewNotice": MessageLookupByLibrary.simpleMessage(
            "Your application is currently locked in read-only mode while under review. You will receive an update once the review is completed."),
        "unexpectedErrorMessage": MessageLookupByLibrary.simpleMessage(
            "Something went wrong. Please try again."),
        "uniqueDaysInMonth": MessageLookupByLibrary.simpleMessage(
            "Unique training days this month"),
        "uniqueDaysInYear": MessageLookupByLibrary.simpleMessage(
            "Unique training days this year"),
        "upcomingSessions":
            MessageLookupByLibrary.simpleMessage("Upcoming Sessions"),
        "uploadDocument":
            MessageLookupByLibrary.simpleMessage("Upload Document"),
        "uploadFailed": MessageLookupByLibrary.simpleMessage(
            "Upload failed. Please try again later"),
        "uploading": MessageLookupByLibrary.simpleMessage("Uploading..."),
        "uploadingPhoto":
            MessageLookupByLibrary.simpleMessage("Uploading photo..."),
        "usdBadge": MessageLookupByLibrary.simpleMessage("USD"),
        "validationAgeRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid age (18 - 80)."),
        "validationAvailabilityHours": MessageLookupByLibrary.simpleMessage(
            "Please check your hours: each working day must end after it starts, with room for at least one session."),
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
        "validationMonthlyPriceRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid monthly rate greater than 0."),
        "validationNameRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter your full name."),
        "validationPhotoRequired": MessageLookupByLibrary.simpleMessage(
            "Please upload a profile photo."),
        "validationRateRequired": MessageLookupByLibrary.simpleMessage(
            "Please specify a valid hourly session rate."),
        "validationSessionPriceRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid session rate greater than 0."),
        "validationSportLocationsRequired": MessageLookupByLibrary.simpleMessage(
            "Please configure at least one location or online training for each selected sport"),
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
        "verifiedCertifications": MessageLookupByLibrary.simpleMessage(
            "Verified Credentials on File"),
        "verifiedCoach": MessageLookupByLibrary.simpleMessage("Verified Coach"),
        "verifyAndContinue":
            MessageLookupByLibrary.simpleMessage("Verify & Continue"),
        "viewAll": MessageLookupByLibrary.simpleMessage("View all"),
        "viewBookingAction":
            MessageLookupByLibrary.simpleMessage("View Booking"),
        "viewCertificate":
            MessageLookupByLibrary.simpleMessage("View Certificate"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("View Details"),
        "viewProfile": MessageLookupByLibrary.simpleMessage("View Profile"),
        "viewSessionsSchedule":
            MessageLookupByLibrary.simpleMessage("View Sessions Schedule"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "weeklyAvailabilityTitle":
            MessageLookupByLibrary.simpleMessage("Weekly Availability"),
        "weeklyFrequencyLabel":
            MessageLookupByLibrary.simpleMessage("Weekly Training Frequency"),
        "weightLoss": MessageLookupByLibrary.simpleMessage("Weight Loss"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
        "welcomeBackUser": m59,
        "whatsIncluded":
            MessageLookupByLibrary.simpleMessage("What\'s Included"),
        "workingDays": MessageLookupByLibrary.simpleMessage("Working Days"),
        "workingHoursDescription": MessageLookupByLibrary.simpleMessage(
            "Configure weekly working days and hours"),
        "yearsExperienceFormat": m60,
        "yearsOfExperience": MessageLookupByLibrary.simpleMessage(
            "Years of Coaching Experience"),
        "yearsOfExperienceLabel":
            MessageLookupByLibrary.simpleMessage("Years of Experience"),
        "yearsUnit": MessageLookupByLibrary.simpleMessage("yrs"),
        "yourGoal": MessageLookupByLibrary.simpleMessage("Your Goal"),
        "yourLevel": MessageLookupByLibrary.simpleMessage("Your Level"),
        "yourProfile": MessageLookupByLibrary.simpleMessage("Your Profile"),
        "yourSports": MessageLookupByLibrary.simpleMessage("Your Sports")
      };
}
