// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(count) =>
      "${Intl.plural(count, one: 'تم اختيار رياضة واحدة', two: 'تم اختيار رياضتين', few: 'تم اختيار ${count} رياضات', many: 'تم اختيار ${count} رياضة', other: 'تم اختيار ${count} رياضة')}";

  static String m1(current, total) => "الخطوة ${current} من ${total}";

  static String m2(name) => "مرحباً بعودتك، ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountCreated":
            MessageLookupByLibrary.simpleMessage("تم إنشاء الحساب"),
        "accountCreatedMessage": MessageLookupByLibrary.simpleMessage(
            "تم إرسال رابط التأكيد إلى بريدك الإلكتروني. يرجى التأكيد قبل تسجيل الدخول."),
        "addPhotoPrompt": MessageLookupByLibrary.simpleMessage(
            "أضف صورة ليتمكن المدربون من التعرف عليك"),
        "advanced": MessageLookupByLibrary.simpleMessage("متقدم"),
        "advancedDesc": MessageLookupByLibrary.simpleMessage(
            "صاحب خبرة وأسعى لتطوير مستواي"),
        "allSetSubtitle": MessageLookupByLibrary.simpleMessage(
            "ملفك الشخصي كمتدرب جاهز. ابدأ الآن في استكشاف أفضل المدربين المتوافقين مع رياضاتك وأهدافك."),
        "allSetTitle": MessageLookupByLibrary.simpleMessage("أنت جاهز تماماً!"),
        "appName": MessageLookupByLibrary.simpleMessage("كوتش هاب"),
        "apple": MessageLookupByLibrary.simpleMessage("أبل"),
        "backToSignIn":
            MessageLookupByLibrary.simpleMessage("العودة لتسجيل الدخول"),
        "beginner": MessageLookupByLibrary.simpleMessage("مبتدئ"),
        "beginnerDesc":
            MessageLookupByLibrary.simpleMessage("في بداية طريقي الرياضي"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "chooseAccountType":
            MessageLookupByLibrary.simpleMessage("اختر نوع الحساب"),
        "chooseYourRole":
            MessageLookupByLibrary.simpleMessage("اختر نوع حسابك"),
        "cityOrRegionOptional":
            MessageLookupByLibrary.simpleMessage("مدينتك أو منطقتك (اختياري)"),
        "coachDashboard":
            MessageLookupByLibrary.simpleMessage("لوحة تحكم المدرب"),
        "coachDashboardPlaceholder": MessageLookupByLibrary.simpleMessage(
            "لوحة تحكم المدرب (المرحلة 3)"),
        "coachDesc": MessageLookupByLibrary.simpleMessage(
            "قدم خدماتك التدريبية، وأدر طلبات التدريب وطور قاعدة عملائك."),
        "competitionPrep":
            MessageLookupByLibrary.simpleMessage("إعداد للبطولات"),
        "completeProfile":
            MessageLookupByLibrary.simpleMessage("إكمال الملف الشخصي"),
        "completeYourProfile":
            MessageLookupByLibrary.simpleMessage("أكمل ملفك الشخصي"),
        "continueButton": MessageLookupByLibrary.simpleMessage("متابعة"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("إنشاء حساب جديد"),
        "demoEndsHere": MessageLookupByLibrary.simpleMessage(
            "(ينتهي العرض التجريبي هنا — الشاشة الرئيسية هي المرحلة الثانية)"),
        "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailAddress":
            MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailHint": MessageLookupByLibrary.simpleMessage("name@example.com"),
        "emailVerificationMessage": MessageLookupByLibrary.simpleMessage(
            "يرجى تأكيد بريدك الإلكتروني للمتابعة."),
        "emailVerificationRequired": MessageLookupByLibrary.simpleMessage(
            "تأكيد البريد الإلكتروني مطلوب"),
        "error": MessageLookupByLibrary.simpleMessage("خطأ"),
        "female": MessageLookupByLibrary.simpleMessage("أنثى"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("هل نسيت كلمة المرور؟"),
        "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
        "fullNameHint": MessageLookupByLibrary.simpleMessage("مثال: أحمد علي"),
        "funRecreation": MessageLookupByLibrary.simpleMessage("ترفيه ومتعة"),
        "gender": MessageLookupByLibrary.simpleMessage("الجنس"),
        "generalFitness":
            MessageLookupByLibrary.simpleMessage("لياقة بدنية عامة"),
        "getStarted": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
        "getStartedNow": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
        "goToSignIn":
            MessageLookupByLibrary.simpleMessage("الذهاب لتسجيل الدخول"),
        "goalSubtitle": MessageLookupByLibrary.simpleMessage(
            "ما هو الهدف الأساسي الذي تسعى لتحقيقه؟"),
        "google": MessageLookupByLibrary.simpleMessage("جوجل"),
        "howWillYouUse":
            MessageLookupByLibrary.simpleMessage("كيف تريد استخدام كوتش هاب؟"),
        "iAmCoach": MessageLookupByLibrary.simpleMessage("أنا مدرب"),
        "iAmTrainee": MessageLookupByLibrary.simpleMessage("أنا متدرب"),
        "intermediate": MessageLookupByLibrary.simpleMessage("متوسط"),
        "intermediateDesc":
            MessageLookupByLibrary.simpleMessage("لدي بعض الخبرة السابقة"),
        "levelSubtitle": MessageLookupByLibrary.simpleMessage(
            "يساعدنا هذا في مطابقتك مع المدربين المناسبين"),
        "male": MessageLookupByLibrary.simpleMessage("ذكر"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "ok": MessageLookupByLibrary.simpleMessage("موافق"),
        "onboardingBadge1":
            MessageLookupByLibrary.simpleMessage("مدربون معتمدون"),
        "onboardingBadge2": MessageLookupByLibrary.simpleMessage("مواعيد مرنة"),
        "onboardingBadge3":
            MessageLookupByLibrary.simpleMessage("متابعة فورية"),
        "onboardingDesc1": MessageLookupByLibrary.simpleMessage(
            "تواصل مع نخبة من أفضل المدربين المعتمدين في كمال الأجسام، الملاكمة، السباحة، والمزيد."),
        "onboardingDesc2": MessageLookupByLibrary.simpleMessage(
            "احجز جلسات تدريبية خاصة وتابع برامج تمارين وتغذية مصممة خصيصاً لتحقيق أهدافك."),
        "onboardingDesc3": MessageLookupByLibrary.simpleMessage(
            "راقب مؤشراتك الحيوية ومستوى أدائك الرياضي واحتفل بإنجازاتك خطوة بخطوة."),
        "onboardingTitle1":
            MessageLookupByLibrary.simpleMessage("اعثر على مدربك المحترف"),
        "onboardingTitle2":
            MessageLookupByLibrary.simpleMessage("خطط مخصصة وحجز فوري"),
        "onboardingTitle3":
            MessageLookupByLibrary.simpleMessage("تتبع تقدمك وحقق بطولاتك"),
        "orContinueWith":
            MessageLookupByLibrary.simpleMessage("أو المتابعة عبر"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
        "passwordLengthHint":
            MessageLookupByLibrary.simpleMessage("6 أحرف على الأقل"),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب ألا تقل كلمة المرور عن 6 أحرف"),
        "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال البريد الإلكتروني"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال اسمك"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال كلمة المرور"),
        "preferNotToSay":
            MessageLookupByLibrary.simpleMessage("أفضل عدم التحديد"),
        "resend": MessageLookupByLibrary.simpleMessage("إعادة الإرسال"),
        "resendEmail":
            MessageLookupByLibrary.simpleMessage("إعادة إرسال البريد"),
        "resetLinkSent":
            MessageLookupByLibrary.simpleMessage("تم إرسال الرابط"),
        "resetLinkSentMessage": MessageLookupByLibrary.simpleMessage(
            "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى مراجعة صندوق الوارد."),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("إعادة تعيين كلمة المرور"),
        "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
            "أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور."),
        "selectSportsSubtitle": MessageLookupByLibrary.simpleMessage(
            "اختر رياضة واحدة أو أكثر ترغب في التدرب عليها"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("إرسال رابط التعيين"),
        "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "سجل دخولك للوصول إلى منصتك الرياضية"),
        "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "انضم إلى كوتش هاب وابدأ رحلتك اليوم"),
        "skillDevelopment":
            MessageLookupByLibrary.simpleMessage("تطوير المهارات"),
        "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
        "skipForNow": MessageLookupByLibrary.simpleMessage("تخطي الآن"),
        "splashSubtitle": MessageLookupByLibrary.simpleMessage(
            "اعثر على مدربك الرياضي المثالي"),
        "sportBasketball": MessageLookupByLibrary.simpleMessage("كرة السلة"),
        "sportBoxing": MessageLookupByLibrary.simpleMessage("الملاكمة"),
        "sportCycling": MessageLookupByLibrary.simpleMessage("ركوب الدراجات"),
        "sportFootball": MessageLookupByLibrary.simpleMessage("كرة القدم"),
        "sportGym": MessageLookupByLibrary.simpleMessage("جيم وكمال أجسام"),
        "sportMartialArts": MessageLookupByLibrary.simpleMessage("فنون قتالية"),
        "sportOther": MessageLookupByLibrary.simpleMessage("أخرى"),
        "sportRunning": MessageLookupByLibrary.simpleMessage("الجري"),
        "sportSwimming": MessageLookupByLibrary.simpleMessage("السباحة"),
        "sportTennis": MessageLookupByLibrary.simpleMessage("التنس"),
        "sportVolleyball": MessageLookupByLibrary.simpleMessage("كرة الطائرة"),
        "sportYoga": MessageLookupByLibrary.simpleMessage("اليوغا"),
        "sportsSelected": m0,
        "startExploringCoaches":
            MessageLookupByLibrary.simpleMessage("ابدأ استكشاف المدربين"),
        "stepOf": m1,
        "success": MessageLookupByLibrary.simpleMessage("نجاح"),
        "tapToUploadPhoto":
            MessageLookupByLibrary.simpleMessage("اضغط لرفع صورة"),
        "traineeDesc": MessageLookupByLibrary.simpleMessage(
            "ابحث عن مدربين محترفين، احجز جلسات تدريبية، وحقق أهدافك الرياضية."),
        "traineeDiscovery":
            MessageLookupByLibrary.simpleMessage("استكشاف المدربين"),
        "traineeMarketplacePlaceholder":
            MessageLookupByLibrary.simpleMessage("شاشة المتدرب (المرحلة 3)"),
        "traineeSetup": MessageLookupByLibrary.simpleMessage("إعداد المتدرب"),
        "verificationEmailSent": MessageLookupByLibrary.simpleMessage(
            "تم إرسال بريد التأكيد بنجاح!"),
        "warning": MessageLookupByLibrary.simpleMessage("تنبيه"),
        "weightLoss": MessageLookupByLibrary.simpleMessage("خسارة الوزن"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("مرحباً بعودتك"),
        "welcomeBackUser": m2,
        "yourGoal": MessageLookupByLibrary.simpleMessage("هدفك التدريبي"),
        "yourLevel": MessageLookupByLibrary.simpleMessage("مستواك الرياضي"),
        "yourProfile": MessageLookupByLibrary.simpleMessage("ملفك الشخصي"),
        "yourSports": MessageLookupByLibrary.simpleMessage("رياضاتك المفضلة")
      };
}
