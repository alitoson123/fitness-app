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

  static String m0(index) => "شهادة إضافية ${index}";

  static String m1(age) => "${age} سنة";

  static String m2(email) => "تم تسجيل الدخول بواسطة: ${email}";

  static String m3(count) => "${count} سنوات خبرة";

  static String m4(count) =>
      "${Intl.plural(count, one: 'مستند واحد مرفق', two: 'مستندان مرفقان', few: '${count} مستندات مرفقة', many: '${count} مستنداً مرفقاً', other: '${count} مستند مرفق')}";

  static String m5(count) =>
      "${Intl.plural(count, one: 'سنة واحدة', two: 'سنتان', few: '${count} سنوات', many: '${count} سنة', other: '${count} سنة')}";

  static String m6(count) => "${count} تقييم";

  static String m7(count) =>
      "${Intl.plural(count, one: 'تم اختيار رياضة واحدة', two: 'تم اختيار رياضتين', few: 'تم اختيار ${count} رياضات', many: 'تم اختيار ${count} رياضة', other: 'تم اختيار ${count} رياضة')}";

  static String m8(current, total) => "الخطوة ${current} من ${total}";

  static String m9(name) => "مرحباً بعودتك، ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutCoach": MessageLookupByLibrary.simpleMessage("نبذة عن المدرب"),
        "accountCreated":
            MessageLookupByLibrary.simpleMessage("تم إنشاء الحساب"),
        "accountCreatedMessage": MessageLookupByLibrary.simpleMessage(
            "تم إرسال رابط التأكيد إلى بريدك الإلكتروني. يرجى التأكيد قبل تسجيل الدخول."),
        "accountDeletedSuccess":
            MessageLookupByLibrary.simpleMessage("تم حذف حسابك بنجاح."),
        "addPhotoPrompt": MessageLookupByLibrary.simpleMessage(
            "أضف صورة ليتمكن المدربون من التعرف عليك"),
        "addSupportingDocument":
            MessageLookupByLibrary.simpleMessage("إضافة مستند داعم"),
        "additionalCertificate": m0,
        "additionalCertificateHint": MessageLookupByLibrary.simpleMessage(
            "ارفع شهادة تدريبية أو اعتماد إضافي"),
        "advanced": MessageLookupByLibrary.simpleMessage("متقدم"),
        "advancedDesc": MessageLookupByLibrary.simpleMessage(
            "صاحب خبرة وأسعى لتطوير مستواي"),
        "age": MessageLookupByLibrary.simpleMessage("العمر"),
        "ageHint": MessageLookupByLibrary.simpleMessage("مثال: 28"),
        "allGenders": MessageLookupByLibrary.simpleMessage("الكل"),
        "allSetSubtitle": MessageLookupByLibrary.simpleMessage(
            "ملفك الشخصي كمتدرب جاهز. ابدأ الآن في استكشاف أفضل المدربين المتوافقين مع رياضاتك وأهدافك."),
        "allSetTitle": MessageLookupByLibrary.simpleMessage("أنت جاهز تماماً!"),
        "allSports": MessageLookupByLibrary.simpleMessage("الكل"),
        "anyExperience": MessageLookupByLibrary.simpleMessage("أي خبرة"),
        "anyRating": MessageLookupByLibrary.simpleMessage("أي تقييم"),
        "appName": MessageLookupByLibrary.simpleMessage("كوتش هاب"),
        "apple": MessageLookupByLibrary.simpleMessage("أبل"),
        "applicationApprovedWelcome": MessageLookupByLibrary.simpleMessage(
            "تمت الموافقة على طلبك! مرحباً بك كمدرب."),
        "applicationNeedsAttention":
            MessageLookupByLibrary.simpleMessage("الطلب بحاجة إلى تعديل"),
        "applicationNotFound":
            MessageLookupByLibrary.simpleMessage("لم يتم العثور على طلب نشط."),
        "applicationSubmitted":
            MessageLookupByLibrary.simpleMessage("تم إرسال الطلب بنجاح!"),
        "applicationSubmittedDesc": MessageLookupByLibrary.simpleMessage(
            "تم استلام طلبك بنجاح وهو قيد المراجعة حالياً من قبل فريق الإدارة."),
        "applicationSubmittedSuccess":
            MessageLookupByLibrary.simpleMessage("تم إرسال طلبك بنجاح للتحقق!"),
        "applyFilters": MessageLookupByLibrary.simpleMessage("تطبيق الفلاتر"),
        "availTemplateFullTime":
            MessageLookupByLibrary.simpleMessage("دوام كامل مرن (يومياً)"),
        "availTemplateMornings": MessageLookupByLibrary.simpleMessage(
            "الفترة الصباحية (6:00 ص - 12:00 م)"),
        "availTemplateWeekdays": MessageLookupByLibrary.simpleMessage(
            "أيام الأسبوع (5:00 م - 10:00 م)"),
        "availTemplateWeekends": MessageLookupByLibrary.simpleMessage(
            "عطلة نهاية الأسبوع (9:00 ص - 6:00 م)"),
        "availabilityHint": MessageLookupByLibrary.simpleMessage(
            "مثال: الأحد إلى الخميس 5:00 م - 10:00 م، السبت 9:00 ص - 2:00 م"),
        "availabilityRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى توضيح المواعيد العامة المتاحة لديك"),
        "availabilityStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "حدد جدول مواعيد التدريب وساعات العمل الأسبوعية"),
        "availabilityTitle": MessageLookupByLibrary.simpleMessage(
            "نظرة عامة على المواعيد المتاحة أسبوعياً"),
        "available": MessageLookupByLibrary.simpleMessage("متاح"),
        "back": MessageLookupByLibrary.simpleMessage("السابق"),
        "backToRoleSelection":
            MessageLookupByLibrary.simpleMessage("العودة لاختيار الدور"),
        "backToSignIn":
            MessageLookupByLibrary.simpleMessage("العودة لتسجيل الدخول"),
        "beginner": MessageLookupByLibrary.simpleMessage("مبتدئ"),
        "beginnerDesc":
            MessageLookupByLibrary.simpleMessage("في بداية طريقي الرياضي"),
        "bio":
            MessageLookupByLibrary.simpleMessage("النبذة التعريفية والخبرات"),
        "bioHint": MessageLookupByLibrary.simpleMessage(
            "أخبر المتدربين عن فلسفتك التدريبية وخبراتك السابقة (30 حرفاً كحد أدنى)..."),
        "bioMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب أن تكون النبذة 30 حرفاً على الأقل"),
        "bookingFeatureComingSoon": MessageLookupByLibrary.simpleMessage(
            "سيتم فتح طلب الحجز في الخطوة التالية!"),
        "camera": MessageLookupByLibrary.simpleMessage("الكاميرا"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "certRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى رفع شهادة تدريبية أو مؤهل معتمد واحد على الأقل"),
        "certifications":
            MessageLookupByLibrary.simpleMessage("الشهادات والاعتمادات"),
        "checkStatusAgain":
            MessageLookupByLibrary.simpleMessage("تحديث الحالة"),
        "chooseAccountType":
            MessageLookupByLibrary.simpleMessage("اختر نوع الحساب"),
        "chooseDocumentSource":
            MessageLookupByLibrary.simpleMessage("اختر مصدر المستند"),
        "choosePhotoSource":
            MessageLookupByLibrary.simpleMessage("اختر مصدر الصورة"),
        "chooseYourRole":
            MessageLookupByLibrary.simpleMessage("اختر نوع حسابك"),
        "city": MessageLookupByLibrary.simpleMessage("المدينة"),
        "cityAbuDhabi": MessageLookupByLibrary.simpleMessage("أبوظبي"),
        "cityAjman": MessageLookupByLibrary.simpleMessage("عجمان"),
        "cityAlAhmadi": MessageLookupByLibrary.simpleMessage("الأحمدي"),
        "cityAlKhor": MessageLookupByLibrary.simpleMessage("الخور"),
        "cityAlRayyan": MessageLookupByLibrary.simpleMessage("الريان"),
        "cityAlWakrah": MessageLookupByLibrary.simpleMessage("الوكرة"),
        "cityAlexandria": MessageLookupByLibrary.simpleMessage("الإسكندرية"),
        "cityAmman": MessageLookupByLibrary.simpleMessage("عَمّان"),
        "cityAqaba": MessageLookupByLibrary.simpleMessage("العقبة"),
        "cityAswan": MessageLookupByLibrary.simpleMessage("أسوان"),
        "cityCairo": MessageLookupByLibrary.simpleMessage("القاهرة"),
        "cityDammam": MessageLookupByLibrary.simpleMessage("الدمام"),
        "cityDoha": MessageLookupByLibrary.simpleMessage("الدوحة"),
        "cityDubai": MessageLookupByLibrary.simpleMessage("دبي"),
        "cityGiza": MessageLookupByLibrary.simpleMessage("الجيزة"),
        "cityHamadTown": MessageLookupByLibrary.simpleMessage("مدينة حمد"),
        "cityHawally": MessageLookupByLibrary.simpleMessage("حولي"),
        "cityHint":
            MessageLookupByLibrary.simpleMessage("مثال: الرياض، القاهرة"),
        "cityIrbid": MessageLookupByLibrary.simpleMessage("إربد"),
        "cityJeddah": MessageLookupByLibrary.simpleMessage("جدة"),
        "cityKhobar": MessageLookupByLibrary.simpleMessage("الخبر"),
        "cityKuwaitCity": MessageLookupByLibrary.simpleMessage("مدينة الكويت"),
        "cityManama": MessageLookupByLibrary.simpleMessage("المنامة"),
        "cityMansoura": MessageLookupByLibrary.simpleMessage("المنصورة"),
        "cityMecca": MessageLookupByLibrary.simpleMessage("مكة المكرمة"),
        "cityMedina": MessageLookupByLibrary.simpleMessage("المدينة المنورة"),
        "cityMuharraq": MessageLookupByLibrary.simpleMessage("المحرق"),
        "cityMuscat": MessageLookupByLibrary.simpleMessage("مسقط"),
        "cityNizwa": MessageLookupByLibrary.simpleMessage("نزوى"),
        "cityOrRegionOptional":
            MessageLookupByLibrary.simpleMessage("مدينتك أو منطقتك (اختياري)"),
        "cityRasAlKhaimah": MessageLookupByLibrary.simpleMessage("رأس الخيمة"),
        "cityRiffa": MessageLookupByLibrary.simpleMessage("الرفاع"),
        "cityRiyadh": MessageLookupByLibrary.simpleMessage("الرياض"),
        "citySalalah": MessageLookupByLibrary.simpleMessage("صلالة"),
        "citySalmiya": MessageLookupByLibrary.simpleMessage("السالمية"),
        "citySharjah": MessageLookupByLibrary.simpleMessage("الشارقة"),
        "citySohar": MessageLookupByLibrary.simpleMessage("صحار"),
        "cityTanta": MessageLookupByLibrary.simpleMessage("طنطا"),
        "cityZarqa": MessageLookupByLibrary.simpleMessage("الزرقاء"),
        "clearDraft": MessageLookupByLibrary.simpleMessage("مسح المسودة"),
        "clearFilters": MessageLookupByLibrary.simpleMessage("مسح الفلاتر"),
        "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
        "coachAgeYears": m1,
        "coachDashboard":
            MessageLookupByLibrary.simpleMessage("لوحة تحكم المدرب"),
        "coachDashboardPlaceholder": MessageLookupByLibrary.simpleMessage(
            "لوحة تحكم المدرب (المرحلة 3)"),
        "coachDesc": MessageLookupByLibrary.simpleMessage(
            "قدم خدماتك التدريبية، وأدر طلبات التدريب وطور قاعدة عملائك."),
        "coachGender": MessageLookupByLibrary.simpleMessage("جنس المدرب"),
        "coachPhotoRequired":
            MessageLookupByLibrary.simpleMessage("الصورة الشخصية مطلوبة"),
        "coachProfileDetails":
            MessageLookupByLibrary.simpleMessage("الملف الشخصي للمدرب"),
        "coachSetupSubtitle": MessageLookupByLibrary.simpleMessage(
            "أنشئ ملفك التدريبي الاحترافي وقدم طلب التحقق"),
        "coachSetupTitle":
            MessageLookupByLibrary.simpleMessage("طلب انضمام مدرب"),
        "coachSuspendedNotice": MessageLookupByLibrary.simpleMessage(
            "تم تقييد الوصول إلى ميزات المدرب. إذا كنت تعتقد أن هذا خطأ أو تحتاج إلى مزيد من المعلومات، يرجى التواصل مع فريق الدعم لدينا."),
        "coachSuspendedSubtitle": MessageLookupByLibrary.simpleMessage(
            "تم تعليق حساب المدرب الخاص بك من قبل الإدارة."),
        "coachSuspendedTitle":
            MessageLookupByLibrary.simpleMessage("تم تعليق الحساب"),
        "coachingCertificates": MessageLookupByLibrary.simpleMessage(
            "الشهادات والاعتمادات التدريبية"),
        "coachingCertificatesHint": MessageLookupByLibrary.simpleMessage(
            "ارفع الشهادات الرياضية أو الدبلومات التدريبية المعتمدة"),
        "competitionPrep":
            MessageLookupByLibrary.simpleMessage("إعداد للبطولات"),
        "completeProfile":
            MessageLookupByLibrary.simpleMessage("إكمال الملف الشخصي"),
        "completeYourProfile":
            MessageLookupByLibrary.simpleMessage("أكمل ملفك الشخصي"),
        "contactSupport":
            MessageLookupByLibrary.simpleMessage("تواصل مع الدعم"),
        "continueButton": MessageLookupByLibrary.simpleMessage("متابعة"),
        "copyEmail":
            MessageLookupByLibrary.simpleMessage("نسخ البريد الإلكتروني"),
        "country": MessageLookupByLibrary.simpleMessage("الدولة"),
        "countryBahrain": MessageLookupByLibrary.simpleMessage("البحرين"),
        "countryEgypt": MessageLookupByLibrary.simpleMessage("مصر"),
        "countryHint":
            MessageLookupByLibrary.simpleMessage("مثال: السعودية، مصر"),
        "countryJordan": MessageLookupByLibrary.simpleMessage("الأردن"),
        "countryKuwait": MessageLookupByLibrary.simpleMessage("الكويت"),
        "countryOman": MessageLookupByLibrary.simpleMessage("سلطنة عُمان"),
        "countryQatar": MessageLookupByLibrary.simpleMessage("قطر"),
        "countrySaudiArabia":
            MessageLookupByLibrary.simpleMessage("المملكة العربية السعودية"),
        "countryUAE":
            MessageLookupByLibrary.simpleMessage("الإمارات العربية المتحدة"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("إنشاء حساب جديد"),
        "credentialsAndQualifications":
            MessageLookupByLibrary.simpleMessage("المؤهلات والخبرات"),
        "currency": MessageLookupByLibrary.simpleMessage("العملة"),
        "currencySAR": MessageLookupByLibrary.simpleMessage("ر.س / ساعة"),
        "currentUserInfo": m2,
        "customWorkoutPlan":
            MessageLookupByLibrary.simpleMessage("توجيه وبرنامج تدريبي مخصص"),
        "dayAvailable": MessageLookupByLibrary.simpleMessage("متاح"),
        "dayFri": MessageLookupByLibrary.simpleMessage("جمعة"),
        "dayFriday": MessageLookupByLibrary.simpleMessage("الجمعة"),
        "dayMon": MessageLookupByLibrary.simpleMessage("إثنين"),
        "dayMonday": MessageLookupByLibrary.simpleMessage("الإثنين"),
        "daySat": MessageLookupByLibrary.simpleMessage("سبت"),
        "daySaturday": MessageLookupByLibrary.simpleMessage("السبت"),
        "daySun": MessageLookupByLibrary.simpleMessage("أحد"),
        "daySunday": MessageLookupByLibrary.simpleMessage("الأحد"),
        "dayThu": MessageLookupByLibrary.simpleMessage("خميس"),
        "dayThursday": MessageLookupByLibrary.simpleMessage("الخميس"),
        "dayTue": MessageLookupByLibrary.simpleMessage("ثلاثاء"),
        "dayTuesday": MessageLookupByLibrary.simpleMessage("الثلاثاء"),
        "dayUnavailable": MessageLookupByLibrary.simpleMessage("غير متاح"),
        "dayWed": MessageLookupByLibrary.simpleMessage("أربعاء"),
        "dayWednesday": MessageLookupByLibrary.simpleMessage("الأربعاء"),
        "defaultCoachBio": MessageLookupByLibrary.simpleMessage(
            "مدرب محترف ومعتمد جاهز لمساعدتك في تحقيق أهدافك البدنية والرياضية."),
        "defaultRejectionReason": MessageLookupByLibrary.simpleMessage(
            "الطلب يحتاج إلى تحديث مستندات التحقق."),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("حذف الحساب"),
        "deleteAccountConfirm":
            MessageLookupByLibrary.simpleMessage("نعم، احذف الحساب"),
        "deleteAccountConfirmationMessage": MessageLookupByLibrary.simpleMessage(
            "هل أنت متأكد من رغبتك في حذف حسابك؟ سيتم حذف جميع بياناتك وإعدادات ملفك الشخصي نهائياً. لا يمكن التراجع عن هذا الإجراء."),
        "deleteAccountConfirmationTitle":
            MessageLookupByLibrary.simpleMessage("حذف الحساب؟"),
        "demoEndsHere": MessageLookupByLibrary.simpleMessage(
            "(ينتهي العرض التجريبي هنا — الشاشة الرئيسية هي المرحلة الثانية)"),
        "directSupport":
            MessageLookupByLibrary.simpleMessage("تواصل وتنسيق مباشر للتمارين"),
        "documentUploadedSuccess":
            MessageLookupByLibrary.simpleMessage("تم رفع المستند بنجاح"),
        "draftRestored": MessageLookupByLibrary.simpleMessage(
            "تمت استعادة المسودة المحفوظة بنجاح."),
        "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
        "editAndResubmit":
            MessageLookupByLibrary.simpleMessage("تعديل وإعادة الإرسال"),
        "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailAddress":
            MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailCopied": MessageLookupByLibrary.simpleMessage(
            "تم نسخ البريد الإلكتروني إلى الحافظة"),
        "emailHint": MessageLookupByLibrary.simpleMessage("name@example.com"),
        "emailVerificationMessage": MessageLookupByLibrary.simpleMessage(
            "يرجى تأكيد بريدك الإلكتروني للمتابعة."),
        "emailVerificationRequired": MessageLookupByLibrary.simpleMessage(
            "تأكيد البريد الإلكتروني مطلوب"),
        "error": MessageLookupByLibrary.simpleMessage("خطأ"),
        "errorLoadingCoachProfile": MessageLookupByLibrary.simpleMessage(
            "فشل تحميل الملف الشخصي للمدرب. انقر لإعادة المحاولة."),
        "errorLoadingCoaches": MessageLookupByLibrary.simpleMessage(
            "فشل تحميل المدربين. اضغط لإعادة المحاولة."),
        "expectedReviewTime": MessageLookupByLibrary.simpleMessage(
            "الوقت المتوقع للمراجعة: 24 - 48 ساعة"),
        "experienceYearsCount": m3,
        "fakeCoachDashboardSubtitle": MessageLookupByLibrary.simpleMessage(
            "مرحباً بك أيها المدرب! هذه شاشة تجريبية لاختبار التنقل وتسجيل الدخول والخروج."),
        "fakeCoachDashboardTitle":
            MessageLookupByLibrary.simpleMessage("لوحة تحكم المدرب"),
        "fakeTraineeHomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "مرحباً بك أيها المتدرب! هذه شاشة تجريبية لاختبار التنقل وتسجيل الدخول والخروج."),
        "fakeTraineeHomeTitle":
            MessageLookupByLibrary.simpleMessage("الرئيسية للمتدرب"),
        "female": MessageLookupByLibrary.simpleMessage("أنثى"),
        "femaleOnly": MessageLookupByLibrary.simpleMessage("سيدات"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage(
            "حجم الملف يتجاوز الحد الأقصى 10 ميجابايت"),
        "fileUploaded":
            MessageLookupByLibrary.simpleMessage("تم اختيار المستند"),
        "filter": MessageLookupByLibrary.simpleMessage("تصفية"),
        "filters": MessageLookupByLibrary.simpleMessage("الفلاتر"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("هل نسيت كلمة المرور؟"),
        "fromTime": MessageLookupByLibrary.simpleMessage("من"),
        "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
        "fullNameHint": MessageLookupByLibrary.simpleMessage("مثال: أحمد علي"),
        "funRecreation": MessageLookupByLibrary.simpleMessage("ترفيه ومتعة"),
        "gallery": MessageLookupByLibrary.simpleMessage("معرض الصور"),
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
        "hourlyRateHint": MessageLookupByLibrary.simpleMessage("مثال: 150"),
        "hourlyRateRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال سعر صحيح أكبر من 0"),
        "howWillYouUse":
            MessageLookupByLibrary.simpleMessage("كيف تريد استخدام كوتش هاب؟"),
        "iAmCoach": MessageLookupByLibrary.simpleMessage("أنا مدرب"),
        "iAmTrainee": MessageLookupByLibrary.simpleMessage("أنا متدرب"),
        "idRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى رفع الهوية الوطنية أو جواز السفر"),
        "intermediate": MessageLookupByLibrary.simpleMessage("متوسط"),
        "intermediateDesc":
            MessageLookupByLibrary.simpleMessage("لدي بعض الخبرة السابقة"),
        "langArabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "langEnglish": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
        "langFrench": MessageLookupByLibrary.simpleMessage("الفرنسية"),
        "langGerman": MessageLookupByLibrary.simpleMessage("الألمانية"),
        "langSpanish": MessageLookupByLibrary.simpleMessage("الإسبانية"),
        "languages":
            MessageLookupByLibrary.simpleMessage("اللغات التي تتحدث بها"),
        "levelSubtitle": MessageLookupByLibrary.simpleMessage(
            "يساعدنا هذا في مطابقتك مع المدربين المناسبين"),
        "male": MessageLookupByLibrary.simpleMessage("ذكر"),
        "maleOnly": MessageLookupByLibrary.simpleMessage("رجال"),
        "minExperienceYears":
            MessageLookupByLibrary.simpleMessage("الحد الأدنى للخبرة"),
        "minimumRating":
            MessageLookupByLibrary.simpleMessage("الحد الأدنى للتقييم"),
        "nationalIdHint": MessageLookupByLibrary.simpleMessage(
            "ارفع صورة واضحة أو ملف PDF للهوية أو الجواز"),
        "nationalIdOrPassport": MessageLookupByLibrary.simpleMessage(
            "الهوية الوطنية أو جواز السفر"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "noAvailabilityListed": MessageLookupByLibrary.simpleMessage(
            "لم يتم تحديد أوقات ثابتة. يمكنك التنسيق عند الطلب."),
        "noCoachesFound":
            MessageLookupByLibrary.simpleMessage("لم يتم العثور على مدربين"),
        "noCoachesFoundDesc": MessageLookupByLibrary.simpleMessage(
            "حاول تعديل البحث أو الفلاتر للعثور على مدربين متاحين."),
        "noDaysSelected":
            MessageLookupByLibrary.simpleMessage("لم يتم تحديد أي أيام"),
        "noReviewsYet": MessageLookupByLibrary.simpleMessage("جديد"),
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
        "oneOnOneTraining":
            MessageLookupByLibrary.simpleMessage("تدريب فردي خاص 1 على 1"),
        "orContinueWith":
            MessageLookupByLibrary.simpleMessage("أو المتابعة عبر"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
        "passwordLengthHint":
            MessageLookupByLibrary.simpleMessage("6 أحرف على الأقل"),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب ألا تقل كلمة المرور عن 6 أحرف"),
        "pdfDocument": MessageLookupByLibrary.simpleMessage("مستند PDF"),
        "pdfUploaded":
            MessageLookupByLibrary.simpleMessage("تم اختيار مستند PDF"),
        "perSessionUnit": MessageLookupByLibrary.simpleMessage("/ جلسة"),
        "phoneHint": MessageLookupByLibrary.simpleMessage("+966 50 123 4567"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
        "photoUploadFailed": MessageLookupByLibrary.simpleMessage(
            "فشل رفع الصورة. يرجى المحاولة مرة أخرى."),
        "photoUploadedSuccess":
            MessageLookupByLibrary.simpleMessage("تم رفع الصورة بنجاح"),
        "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال البريد الإلكتروني"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال اسمك"),
        "pleaseEnterPassword":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال كلمة المرور"),
        "pleaseEnterPhone":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال رقم الهاتف"),
        "pleaseSelectLanguage": MessageLookupByLibrary.simpleMessage(
            "يرجى اختيار لغة واحدة على الأقل"),
        "pleaseSelectSport": MessageLookupByLibrary.simpleMessage(
            "يرجى اختيار رياضة واحدة على الأقل"),
        "preferNotToSay":
            MessageLookupByLibrary.simpleMessage("أفضل عدم التحديد"),
        "pricePerSession":
            MessageLookupByLibrary.simpleMessage("سعر الجلسة الواحدة"),
        "pricePerSessionHint":
            MessageLookupByLibrary.simpleMessage("مثال: 150"),
        "priceRange": MessageLookupByLibrary.simpleMessage("نطاق السعر"),
        "pricingStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "حدد سعر جلسة التدريب والعملة المفضلة لديك"),
        "pricingTipText":
            MessageLookupByLibrary.simpleMessage("حدد سعراً للجلسة الواحدة."),
        "pricingTitle":
            MessageLookupByLibrary.simpleMessage("سعر ساعة التدريب"),
        "quickAvailabilityTemplates": MessageLookupByLibrary.simpleMessage(
            "نماذج سريعة للمواعيد المتاحة"),
        "rejectionReasonLabel":
            MessageLookupByLibrary.simpleMessage("ملاحظات فريق الإدارة:"),
        "removeDocument": MessageLookupByLibrary.simpleMessage("حذف المستند"),
        "removePhoto": MessageLookupByLibrary.simpleMessage("إزالة الصورة"),
        "replaceFile": MessageLookupByLibrary.simpleMessage("استبدال المستند"),
        "requestTraining":
            MessageLookupByLibrary.simpleMessage("طلب جلسة تدريب"),
        "requiredBadge": MessageLookupByLibrary.simpleMessage("مطلوب"),
        "resend": MessageLookupByLibrary.simpleMessage("إعادة الإرسال"),
        "resendEmail":
            MessageLookupByLibrary.simpleMessage("إعادة إرسال البريد"),
        "reset": MessageLookupByLibrary.simpleMessage("إعادة ضبط"),
        "resetLinkSent":
            MessageLookupByLibrary.simpleMessage("تم إرسال الرابط"),
        "resetLinkSentMessage": MessageLookupByLibrary.simpleMessage(
            "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى مراجعة صندوق الوارد."),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("إعادة تعيين كلمة المرور"),
        "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
            "أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور."),
        "resubmitApplication":
            MessageLookupByLibrary.simpleMessage("إعادة إرسال الطلب"),
        "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
        "reviewAge": MessageLookupByLibrary.simpleMessage("العمر"),
        "reviewAttached": MessageLookupByLibrary.simpleMessage("تم الرفع"),
        "reviewAvailability":
            MessageLookupByLibrary.simpleMessage("المواعيد المتاحة"),
        "reviewCertificates":
            MessageLookupByLibrary.simpleMessage("الشهادات التدريبية"),
        "reviewFilesAttached": m4,
        "reviewGender": MessageLookupByLibrary.simpleMessage("الجنس"),
        "reviewGovernmentId":
            MessageLookupByLibrary.simpleMessage("الهوية الوطنية أو الجواز"),
        "reviewHourlyRate": MessageLookupByLibrary.simpleMessage("سعر الساعة"),
        "reviewLocation": MessageLookupByLibrary.simpleMessage("الموقع"),
        "reviewMissing": MessageLookupByLibrary.simpleMessage("غير مرفق"),
        "reviewNoneSpecified": MessageLookupByLibrary.simpleMessage("لم يُحدد"),
        "reviewSports": MessageLookupByLibrary.simpleMessage("الرياضات"),
        "reviewSubtitle": MessageLookupByLibrary.simpleMessage(
            "يرجى التأكد من صحة كافة البيانات قبل الإرسال للمراجعة."),
        "reviewTitle": MessageLookupByLibrary.simpleMessage("مراجعة الطلب"),
        "reviewYearsCount": m5,
        "reviewsCount": m6,
        "searchCoaches": MessageLookupByLibrary.simpleMessage(
            "ابحث عن المدربين أو الرياضات..."),
        "selectCity": MessageLookupByLibrary.simpleMessage("اختر المدينة"),
        "selectCountry": MessageLookupByLibrary.simpleMessage("اختر الدولة"),
        "selectCountryFirst":
            MessageLookupByLibrary.simpleMessage("يرجى اختيار الدولة أولاً"),
        "selectCurrency": MessageLookupByLibrary.simpleMessage("اختر العملة"),
        "selectDaysAndHours": MessageLookupByLibrary.simpleMessage(
            "حدد الأيام والساعات المتاحة لديك للتدريب."),
        "selectLanguages": MessageLookupByLibrary.simpleMessage("اختر اللغات"),
        "selectSportsSubtitle": MessageLookupByLibrary.simpleMessage(
            "اختر رياضة واحدة أو أكثر ترغب في التدرب عليها"),
        "selectSportsYouCoach":
            MessageLookupByLibrary.simpleMessage("اختر الرياضات التي تدربها"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("إرسال رابط التعيين"),
        "sessionPricing": MessageLookupByLibrary.simpleMessage("سعر الجلسة"),
        "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "سجل دخولك للوصول إلى منصتك الرياضية"),
        "signOut": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
        "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "انضم إلى كوتش هاب وابدأ رحلتك اليوم"),
        "skillDevelopment":
            MessageLookupByLibrary.simpleMessage("تطوير المهارات"),
        "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
        "skipForNow": MessageLookupByLibrary.simpleMessage("تخطي الآن"),
        "sortBy": MessageLookupByLibrary.simpleMessage("ترتيب حسب"),
        "sortExperienceHighToLow":
            MessageLookupByLibrary.simpleMessage("الأكثر خبرة"),
        "sortPriceHighToLow":
            MessageLookupByLibrary.simpleMessage("السعر: من الأعلى للأقل"),
        "sortPriceLowToHigh":
            MessageLookupByLibrary.simpleMessage("السعر: من الأقل للأعلى"),
        "sortRatingHighToLow":
            MessageLookupByLibrary.simpleMessage("التقييم: الأعلى أولاً"),
        "sortRecommended": MessageLookupByLibrary.simpleMessage("الموصى به"),
        "specialties": MessageLookupByLibrary.simpleMessage("التخصصات"),
        "specialties1":
            MessageLookupByLibrary.simpleMessage("التخصصات ومجالات التركيز"),
        "specialtiesHint": MessageLookupByLibrary.simpleMessage(
            "مثال: القوة البدنية، إنقاص الوزن، التكنيك"),
        "splashSubtitle": MessageLookupByLibrary.simpleMessage(
            "اعثر على مدربك الرياضي المثالي"),
        "spokenLanguages": MessageLookupByLibrary.simpleMessage("اللغات"),
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
        "sportsAndSpecialties":
            MessageLookupByLibrary.simpleMessage("الرياضات والتخصصات"),
        "sportsSelected": m7,
        "startExploringCoaches":
            MessageLookupByLibrary.simpleMessage("ابدأ استكشاف المدربين"),
        "stepAvailability":
            MessageLookupByLibrary.simpleMessage("المواعيد الأسبوعية"),
        "stepOf": m8,
        "stepPersonalInfo":
            MessageLookupByLibrary.simpleMessage("المعلومات الشخصية"),
        "stepPricing": MessageLookupByLibrary.simpleMessage("التسعير"),
        "stepPricingAvailability":
            MessageLookupByLibrary.simpleMessage("السعر والمواعيد"),
        "stepProfessionalInfo":
            MessageLookupByLibrary.simpleMessage("الخبرة والرياضات"),
        "stepReviewSubmit":
            MessageLookupByLibrary.simpleMessage("المراجعة والإرسال"),
        "stepVerificationDocs":
            MessageLookupByLibrary.simpleMessage("مستندات التحقق"),
        "submitApplication":
            MessageLookupByLibrary.simpleMessage("إرسال طلب الانضمام"),
        "submittingApplication":
            MessageLookupByLibrary.simpleMessage("جاري إرسال الطلب..."),
        "success": MessageLookupByLibrary.simpleMessage("نجاح"),
        "supportEmail":
            MessageLookupByLibrary.simpleMessage("support@coachhub.app"),
        "supportModalDesc": MessageLookupByLibrary.simpleMessage(
            "فريق الدعم لدينا متواجد لمساعدتك في استفسارات حسابك وطلب الانضمام الخاص بك."),
        "supportModalTitle":
            MessageLookupByLibrary.simpleMessage("المساعدة والدعم"),
        "supportingDocument":
            MessageLookupByLibrary.simpleMessage("مستند داعم"),
        "suspendedStatusBadge": MessageLookupByLibrary.simpleMessage("معلق"),
        "tapToUploadPhoto":
            MessageLookupByLibrary.simpleMessage("اضغط لرفع صورة"),
        "testModeBadge": MessageLookupByLibrary.simpleMessage("وضع التجربة"),
        "toTime": MessageLookupByLibrary.simpleMessage("إلى"),
        "traineeDesc": MessageLookupByLibrary.simpleMessage(
            "ابحث عن مدربين محترفين، احجز جلسات تدريبية، وحقق أهدافك الرياضية."),
        "traineeDiscovery":
            MessageLookupByLibrary.simpleMessage("استكشاف المدربين"),
        "traineeMarketplacePlaceholder":
            MessageLookupByLibrary.simpleMessage("شاشة المتدرب (المرحلة 3)"),
        "traineeSetup": MessageLookupByLibrary.simpleMessage("إعداد المتدرب"),
        "traineeSetupSubtitle": MessageLookupByLibrary.simpleMessage(
            "أنشئ ملفك الشخصي للمتدرب وابدأ رحلتك الرياضية"),
        "unavailable": MessageLookupByLibrary.simpleMessage("غير متاح"),
        "underReviewNotice": MessageLookupByLibrary.simpleMessage(
            "طلبك حالياً في وضع القراءة فقط أثناء المراجعة. سيتم إشعارك فور اتخاذ القرار."),
        "uploadDocument": MessageLookupByLibrary.simpleMessage("رفع المستند"),
        "uploadFailed": MessageLookupByLibrary.simpleMessage(
            "فشل الرفع، يرجى المحاولة مرة أخرى لاحقاً"),
        "uploading": MessageLookupByLibrary.simpleMessage("جاري الرفع..."),
        "uploadingPhoto":
            MessageLookupByLibrary.simpleMessage("جاري رفع الصورة..."),
        "validationAgeRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال عمر صحيح (18 - 80)."),
        "validationAvailabilityRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى كتابة المواعيد المتاحة لديك."),
        "validationBioMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب ألا تقل النبذة التعريفية عن 30 حرفاً."),
        "validationCertRequired": MessageLookupByLibrary.simpleMessage(
            "رفع شهادة تدريبية أو اعتماد واحد على الأقل إلزامي."),
        "validationCheckFields": MessageLookupByLibrary.simpleMessage(
            "يرجى مراجعة الحقول المطلوبة."),
        "validationCityRequired":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال المدينة."),
        "validationCountryRequired":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال الدولة."),
        "validationGenderRequired":
            MessageLookupByLibrary.simpleMessage("يرجى تحديد الجنس."),
        "validationIdRequired": MessageLookupByLibrary.simpleMessage(
            "رفع الهوية الوطنية أو جواز السفر إلزامي."),
        "validationLanguageRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى اختيار لغة واحدة على الأقل."),
        "validationNameRequired":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال اسمك الكامل."),
        "validationPhotoRequired":
            MessageLookupByLibrary.simpleMessage("يرجى رفع صورة شخصية."),
        "validationRateRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال سعر صحيح لجلسة التدريب."),
        "validationSportRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى اختيار رياضة واحدة على الأقل."),
        "verificationDocsSubtitle": MessageLookupByLibrary.simpleMessage(
            "الهوية الوطنية أو جواز السفر وشهادة تدريبية واحدة على الأقل إلزامية للتحقق."),
        "verificationDocsTitle":
            MessageLookupByLibrary.simpleMessage("رفع مستندات التحقق"),
        "verificationEmailSent": MessageLookupByLibrary.simpleMessage(
            "تم إرسال بريد التأكيد بنجاح!"),
        "verificationPendingSubtitle": MessageLookupByLibrary.simpleMessage(
            "يقوم فريق الإشراف بمراجعة ملفك الشخصي ومستنداتك."),
        "verificationPendingTitle":
            MessageLookupByLibrary.simpleMessage("طلبك قيد المراجعة والتحقق"),
        "verifiedCertifications":
            MessageLookupByLibrary.simpleMessage("شهادات معتمدة وموثقة"),
        "verifiedCoach": MessageLookupByLibrary.simpleMessage("مدرب موثق"),
        "viewCertificate": MessageLookupByLibrary.simpleMessage("عرض الشهادة"),
        "viewProfile": MessageLookupByLibrary.simpleMessage("عرض الملف الشخصي"),
        "warning": MessageLookupByLibrary.simpleMessage("تنبيه"),
        "weeklyAvailabilityTitle":
            MessageLookupByLibrary.simpleMessage("أوقات التوفر الأسبوعية"),
        "weightLoss": MessageLookupByLibrary.simpleMessage("خسارة الوزن"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("مرحباً بعودتك"),
        "welcomeBackUser": m9,
        "whatsIncluded":
            MessageLookupByLibrary.simpleMessage("ما تشمله الجلسة"),
        "yearsOfExperience":
            MessageLookupByLibrary.simpleMessage("سنوات الخبرة في التدريب"),
        "yourGoal": MessageLookupByLibrary.simpleMessage("هدفك التدريبي"),
        "yourLevel": MessageLookupByLibrary.simpleMessage("مستواك الرياضي"),
        "yourProfile": MessageLookupByLibrary.simpleMessage("ملفك الشخصي"),
        "yourSports": MessageLookupByLibrary.simpleMessage("رياضاتك المفضلة")
      };
}
