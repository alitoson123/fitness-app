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

  static String m0(count) => "${count} أيام عمل";

  static String m1(index) => "شهادة إضافية ${index}";

  static String m2(count) => "~${count} جلسات";

  static String m3(coachName) =>
      "تم إرسال طلب التدريب إلى الكابتن ${coachName}. سيتم إشعارك فور الرد على طلبك.";

  static String m4(age) => "${age} سنة";

  static String m5(count) => "يرجى تحديد ${count} حصص للمتابعة";

  static String m6(hours, mins) => "تبدأ خلال ${hours}س ${mins}د";

  static String m7(mins) => "تبدأ خلال ${mins}د";

  static String m8(time) => "اليوم، ${time}";

  static String m9(time) => "غداً، ${time}";

  static String m10(email) => "تم تسجيل الدخول بواسطة: ${email}";

  static String m11(count) => "${count} أيام / أسبوع";

  static String m12(day) =>
      "يجب أن يكون وقت الانتهاء بعد وقت البدء ليوم ${day}.";

  static String m13(day, duration) =>
      "يجب أن تكون ساعات العمل ليوم ${day} كافية لـ ${duration} دقيقة على الأقل.";

  static String m14(count) => "${count} سنوات خبرة";

  static String m15(name) => "مساء الخير، ${name}";

  static String m16(name) => "مساء الخير، ${name}";

  static String m17(name) => "صباح الخير، ${name}";

  static String m18(minutes) => "${minutes} دقيقة";

  static String m19(price) => "${price} \$ / شهرياً";

  static String m20(current, total) => "تم اختيار ${current} من ${total} حصص";

  static String m21(phone) =>
      "أدخل الرمز المكون من 6 أرقام المرسل إلى ${phone}";

  static String m22(price) => "${price} \$";

  static String m23(name) =>
      "هل أنت متأكد من رغبتك في رفض هذا الطلب من ${name}؟";

  static String m24(seconds) => "إعادة الإرسال خلال ${seconds} ثانية";

  static String m25(count) =>
      "${Intl.plural(count, one: 'مستند واحد مرفق', two: 'مستندان مرفقان', few: '${count} مستندات مرفقة', many: '${count} مستنداً مرفقاً', other: '${count} مستند مرفق')}";

  static String m26(count) =>
      "${Intl.plural(count, one: 'سنة واحدة', two: 'سنتان', few: '${count} سنوات', many: '${count} سنة', other: '${count} سنة')}";

  static String m27(count) => "${count} تقييم";

  static String m28(count) => "اختر ${count} حصص لإكمال اشتراكك الشهري";

  static String m29(count, total) => "الحصص المختارة (${count}/${total})";

  static String m30(days) => "خلال ${days} أيام";

  static String m31(hours) => "خلال ${hours} ساعات";

  static String m32(reason) => "سبب الرفض: ${reason}";

  static String m33(number) => "حصة ${number}";

  static String m34(price) => "${price} \$ / حصة";

  static String m35(name) => "جلسة مع ${name}";

  static String m36(current, total) => "${current}/${total} حصص";

  static String m37(count) =>
      "${Intl.plural(count, one: 'تم اختيار رياضة واحدة', two: 'تم اختيار رياضتين', few: 'تم اختيار ${count} رياضات', many: 'تم اختيار ${count} رياضة', other: 'تم اختيار ${count} رياضة')}";

  static String m38(current, total) => "الخطوة ${current} من ${total}";

  static String m39(count) =>
      "${Intl.plural(count, one: 'جلسة قادمة واحدة', two: 'جلستان قادمتان', few: '${count} جلسات قادمة', many: '${count} جلسة قادمة', other: '${count} جلسة قادمة')}";

  static String m40(count) =>
      "${Intl.plural(count, one: 'جلسة سابقة واحدة', two: 'جلستان سابقتان', few: '${count} جلسات سابقة', many: '${count} جلسة سابقة', other: '${count} جلسة سابقة')}";

  static String m41(count) =>
      "${Intl.plural(count, one: 'طلب معلق واحد', two: 'طلبان معلقان', few: '${count} طلبات معلقة', many: '${count} طلباً معلقاً', other: '${count} طلب معلق')}";

  static String m42(hours) => "${hours} ساعة عمل";

  static String m43(name) => "مرحباً بعودتك، ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutCoach": MessageLookupByLibrary.simpleMessage("نبذة عن المدرب"),
        "acceptNewTime":
            MessageLookupByLibrary.simpleMessage("قبول الموعد الجديد"),
        "acceptRequest": MessageLookupByLibrary.simpleMessage("قبول"),
        "accountCreated":
            MessageLookupByLibrary.simpleMessage("تم إنشاء الحساب"),
        "accountCreatedMessage": MessageLookupByLibrary.simpleMessage(
            "تم إرسال رابط التأكيد إلى بريدك الإلكتروني. يرجى التأكيد قبل تسجيل الدخول."),
        "accountDeletedSuccess":
            MessageLookupByLibrary.simpleMessage("تم حذف حسابك بنجاح."),
        "accountSettings":
            MessageLookupByLibrary.simpleMessage("إعدادات الحساب"),
        "activeDaysCount": m0,
        "addPhotoPrompt": MessageLookupByLibrary.simpleMessage(
            "أضف صورة ليتمكن المدربون من التعرف عليك"),
        "addSupportingDocument":
            MessageLookupByLibrary.simpleMessage("إضافة مستند داعم"),
        "additionalCertificate": m1,
        "additionalCertificateHint": MessageLookupByLibrary.simpleMessage(
            "ارفع شهادة تدريبية أو اعتماد إضافي"),
        "additionalNotesOptional":
            MessageLookupByLibrary.simpleMessage("ملاحظات أو أهداف (اختياري)"),
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
        "applyToAllActiveDays": MessageLookupByLibrary.simpleMessage(
            "تطبيق هذه الساعات على كافة أيام العمل"),
        "approximateSessionsCount": m2,
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
        "availabilitySavedSuccess":
            MessageLookupByLibrary.simpleMessage("تم حفظ جدول التوفر بنجاح."),
        "availabilityStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "حدد جدول مواعيد التدريب وساعات العمل الأسبوعية"),
        "availabilitySubtitle": MessageLookupByLibrary.simpleMessage(
            "حدد أيام العمل الأسبوعية، ساعات التدريب، ومدة الجلسة الافتراضية."),
        "availabilityTitle": MessageLookupByLibrary.simpleMessage(
            "نظرة عامة على المواعيد المتاحة أسبوعياً"),
        "available": MessageLookupByLibrary.simpleMessage("متاح"),
        "back": MessageLookupByLibrary.simpleMessage("السابق"),
        "backToExplore":
            MessageLookupByLibrary.simpleMessage("استكشاف المزيد من المدربين"),
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
        "bookNewSession":
            MessageLookupByLibrary.simpleMessage("حجز جلسة جديدة"),
        "bookingFeatureComingSoon": MessageLookupByLibrary.simpleMessage(
            "سيتم فتح طلب الحجز في الخطوة التالية!"),
        "bookingNotesPlaceholder": MessageLookupByLibrary.simpleMessage(
            "اذكر أهدافك التدريبية أو أي إصابات سابقة أو متطلبات..."),
        "bookingRequestTitle":
            MessageLookupByLibrary.simpleMessage("طلب جلسة تدريبية"),
        "bookingSuccessDescription": m3,
        "bookingSuccessTitle":
            MessageLookupByLibrary.simpleMessage("تم إرسال طلبك بنجاح!"),
        "bookingSummaryTitle":
            MessageLookupByLibrary.simpleMessage("ملخص الطلب"),
        "bookingTypeLabel": MessageLookupByLibrary.simpleMessage("نوع الحجز"),
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
        "clearAllSessions": MessageLookupByLibrary.simpleMessage("مسح الكل"),
        "clearDraft": MessageLookupByLibrary.simpleMessage("مسح المسودة"),
        "clearFilters": MessageLookupByLibrary.simpleMessage("مسح الفلاتر"),
        "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
        "coachAgeYears": m4,
        "coachBookingsTitle": MessageLookupByLibrary.simpleMessage("الحجوزات"),
        "coachDashboard":
            MessageLookupByLibrary.simpleMessage("لوحة تحكم المدرب"),
        "coachDashboardPlaceholder": MessageLookupByLibrary.simpleMessage(
            "لوحة تحكم المدرب (المرحلة 3)"),
        "coachDashboardSubtitle": MessageLookupByLibrary.simpleMessage(
            "إدارة جدولك ومواعيدك وجلسات التدريب الخاصة بك."),
        "coachDesc": MessageLookupByLibrary.simpleMessage(
            "قدم خدماتك التدريبية، وأدر طلبات التدريب وطور قاعدة عملائك."),
        "coachGender": MessageLookupByLibrary.simpleMessage("جنس المدرب"),
        "coachHasNoAvailability": MessageLookupByLibrary.simpleMessage(
            "المدرب لم يحدد جدول مواعيد حالياً."),
        "coachNavAvailability":
            MessageLookupByLibrary.simpleMessage("المواعيد"),
        "coachNavBookings": MessageLookupByLibrary.simpleMessage("الحجوزات"),
        "coachNavDashboard": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "coachPhotoRequired":
            MessageLookupByLibrary.simpleMessage("الصورة الشخصية مطلوبة"),
        "coachProfileDetails":
            MessageLookupByLibrary.simpleMessage("الملف الشخصي للمدرب"),
        "coachProposedNewTime": MessageLookupByLibrary.simpleMessage(
            "طلب الكابتن موعداً جديداً للجلسة"),
        "coachReadySubtitle": MessageLookupByLibrary.simpleMessage(
            "جاهز لجلسات التدريب القادمة؟"),
        "coachReasonLabel":
            MessageLookupByLibrary.simpleMessage("ملاحظة الكابتن"),
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
        "codeSentSuccess":
            MessageLookupByLibrary.simpleMessage("تم إرسال رمز التحقق بنجاح!"),
        "competitionPrep":
            MessageLookupByLibrary.simpleMessage("إعداد للبطولات"),
        "completeProfile":
            MessageLookupByLibrary.simpleMessage("إكمال الملف الشخصي"),
        "completeYourProfile":
            MessageLookupByLibrary.simpleMessage("أكمل ملفك الشخصي"),
        "confirmAndSendRequest":
            MessageLookupByLibrary.simpleMessage("تأكيد وإرسال الطلب"),
        "confirmDecline": MessageLookupByLibrary.simpleMessage("تأكيد الرفض"),
        "confirmSessionsCountPrompt": m5,
        "confirmedSessionsTab": MessageLookupByLibrary.simpleMessage("المؤكدة"),
        "contactSupport":
            MessageLookupByLibrary.simpleMessage("تواصل مع الدعم"),
        "continueButton": MessageLookupByLibrary.simpleMessage("متابعة"),
        "copyEmail":
            MessageLookupByLibrary.simpleMessage("نسخ البريد الإلكتروني"),
        "countdownHoursMins": m6,
        "countdownMins": m7,
        "countdownToday": m8,
        "countdownTomorrow": m9,
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
        "currentUserInfo": m10,
        "customWorkoutPlan":
            MessageLookupByLibrary.simpleMessage("توجيه وبرنامج تدريبي مخصص"),
        "dayAvailable": MessageLookupByLibrary.simpleMessage("متاح"),
        "dayFri": MessageLookupByLibrary.simpleMessage("جمعة"),
        "dayFriday": MessageLookupByLibrary.simpleMessage("الجمعة"),
        "dayMon": MessageLookupByLibrary.simpleMessage("إثنين"),
        "dayMonday": MessageLookupByLibrary.simpleMessage("الإثنين"),
        "daySat": MessageLookupByLibrary.simpleMessage("سبت"),
        "daySaturday": MessageLookupByLibrary.simpleMessage("السبت"),
        "dayStatusAvailable":
            MessageLookupByLibrary.simpleMessage("متاح لاستقبال الحجوزات"),
        "dayStatusOff": MessageLookupByLibrary.simpleMessage("يوم عطلة"),
        "daySun": MessageLookupByLibrary.simpleMessage("أحد"),
        "daySunday": MessageLookupByLibrary.simpleMessage("الأحد"),
        "dayThu": MessageLookupByLibrary.simpleMessage("خميس"),
        "dayThursday": MessageLookupByLibrary.simpleMessage("الخميس"),
        "dayTue": MessageLookupByLibrary.simpleMessage("ثلاثاء"),
        "dayTuesday": MessageLookupByLibrary.simpleMessage("الثلاثاء"),
        "dayUnavailable": MessageLookupByLibrary.simpleMessage("غير متاح"),
        "dayWed": MessageLookupByLibrary.simpleMessage("أربعاء"),
        "dayWednesday": MessageLookupByLibrary.simpleMessage("الأربعاء"),
        "daysPerWeekCount": m11,
        "declineConfirmMessage": MessageLookupByLibrary.simpleMessage(
            "في حال الرفض، سيتم إلغاء هذا الحجز وستحتاج إلى حجز جلسة جديدة. هل تود المتابعة؟"),
        "declineConfirmTitle":
            MessageLookupByLibrary.simpleMessage("رفض الموعد المقترح؟"),
        "declineReschedule":
            MessageLookupByLibrary.simpleMessage("رفض وإلغاء الحجز"),
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
        "didNotReceiveCode":
            MessageLookupByLibrary.simpleMessage("لم يصلك الرمز؟"),
        "directSupport":
            MessageLookupByLibrary.simpleMessage("تواصل وتنسيق مباشر للتمارين"),
        "documentUploadedSuccess":
            MessageLookupByLibrary.simpleMessage("تم رفع المستند بنجاح"),
        "draftRestored": MessageLookupByLibrary.simpleMessage(
            "تمت استعادة المسودة المحفوظة بنجاح."),
        "durationMonthsLabel":
            MessageLookupByLibrary.simpleMessage("مدة الاشتراك"),
        "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
        "editAndResubmit":
            MessageLookupByLibrary.simpleMessage("تعديل وإعادة الإرسال"),
        "editNumber": MessageLookupByLibrary.simpleMessage("تعديل"),
        "editProfile":
            MessageLookupByLibrary.simpleMessage("تعديل الملف الشخصي"),
        "egypt": MessageLookupByLibrary.simpleMessage("مصر"),
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
        "endTime": MessageLookupByLibrary.simpleMessage("وقت الانتهاء"),
        "error": MessageLookupByLibrary.simpleMessage("خطأ"),
        "errorInvalidTimeRange": m12,
        "errorLoadingCoachProfile": MessageLookupByLibrary.simpleMessage(
            "فشل تحميل الملف الشخصي للمدرب. انقر لإعادة المحاولة."),
        "errorLoadingCoaches": MessageLookupByLibrary.simpleMessage(
            "فشل تحميل المدربين. اضغط لإعادة المحاولة."),
        "errorNoWorkingDays": MessageLookupByLibrary.simpleMessage(
            "يرجى تحديد يوم عمل واحد على الأقل."),
        "errorTimeWindowTooShort": m13,
        "expectedReviewTime": MessageLookupByLibrary.simpleMessage(
            "الوقت المتوقع للمراجعة: 24 - 48 ساعة"),
        "experienceYearsCount": m14,
        "fakeCoachDashboardSubtitle": MessageLookupByLibrary.simpleMessage(
            "مرحباً بك أيها المدرب! هذه شاشة تجريبية لاختبار التنقل وتسجيل الدخول والخروج."),
        "fakeCoachDashboardTitle":
            MessageLookupByLibrary.simpleMessage("لوحة تحكم المدرب"),
        "fakeTraineeHomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "مرحباً بك أيها المتدرب! هذه شاشة تجريبية لاختبار التنقل وتسجيل الدخول والخروج."),
        "fakeTraineeHomeTitle":
            MessageLookupByLibrary.simpleMessage("الرئيسية للمتدرب"),
        "favoriteSports":
            MessageLookupByLibrary.simpleMessage("الرياضات والأنشطة"),
        "female": MessageLookupByLibrary.simpleMessage("أنثى"),
        "femaleOnly": MessageLookupByLibrary.simpleMessage("سيدات"),
        "fileTooLarge": MessageLookupByLibrary.simpleMessage(
            "حجم الملف يتجاوز الحد الأقصى 10 ميجابايت"),
        "fileUploaded":
            MessageLookupByLibrary.simpleMessage("تم اختيار المستند"),
        "filter": MessageLookupByLibrary.simpleMessage("تصفية"),
        "filters": MessageLookupByLibrary.simpleMessage("الفلاتر"),
        "fitnessGoal": MessageLookupByLibrary.simpleMessage("هدف التدريب"),
        "fitnessLevel": MessageLookupByLibrary.simpleMessage("مستوى اللياقة"),
        "fitnessProfile":
            MessageLookupByLibrary.simpleMessage("اللياقة والأهداف"),
        "flexibleSchedule":
            MessageLookupByLibrary.simpleMessage("مرن / بالتنسيق مع الكابتن"),
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
        "greetingAfternoon": m15,
        "greetingEvening": m16,
        "greetingMorning": m17,
        "groupLater": MessageLookupByLibrary.simpleMessage("المواعيد القادمة"),
        "groupPast": MessageLookupByLibrary.simpleMessage("جلسات سابقة"),
        "groupThisWeek": MessageLookupByLibrary.simpleMessage("هذا الأسبوع"),
        "groupToday": MessageLookupByLibrary.simpleMessage("اليوم"),
        "groupTomorrow": MessageLookupByLibrary.simpleMessage("غداً"),
        "hourlyRateHint": MessageLookupByLibrary.simpleMessage("مثال: 150"),
        "hourlyRateRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال سعر صحيح أكبر من 0"),
        "hoursAppliedToAllDays": MessageLookupByLibrary.simpleMessage(
            "تم تطبيق الساعات على كافة أيام العمل"),
        "howWillYouUse":
            MessageLookupByLibrary.simpleMessage("كيف تريد استخدام كوتش هاب؟"),
        "iAmCoach": MessageLookupByLibrary.simpleMessage("أنا مدرب"),
        "iAmTrainee": MessageLookupByLibrary.simpleMessage("أنا متدرب"),
        "idRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى رفع الهوية الوطنية أو جواز السفر"),
        "incomingRequestsTab": MessageLookupByLibrary.simpleMessage("الطلبات"),
        "intermediate": MessageLookupByLibrary.simpleMessage("متوسط"),
        "intermediateDesc":
            MessageLookupByLibrary.simpleMessage("لدي بعض الخبرة السابقة"),
        "invalidOtpCode": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال رمز مكون من 6 أرقام صحيح"),
        "invalidPhoneFormat": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال رقم هاتف صحيح للدولة المحددة"),
        "langArabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "langEnglish": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
        "langFrench": MessageLookupByLibrary.simpleMessage("الفرنسية"),
        "langGerman": MessageLookupByLibrary.simpleMessage("الألمانية"),
        "langSpanish": MessageLookupByLibrary.simpleMessage("الإسبانية"),
        "languages":
            MessageLookupByLibrary.simpleMessage("اللغات التي تتحدث بها"),
        "lebanon": MessageLookupByLibrary.simpleMessage("لبنان"),
        "levelSubtitle": MessageLookupByLibrary.simpleMessage(
            "يساعدنا هذا في مطابقتك مع المدربين المناسبين"),
        "loadProfileError": MessageLookupByLibrary.simpleMessage(
            "فشل تحميل الملف الشخصي. انقر للمحاولة مجدداً."),
        "male": MessageLookupByLibrary.simpleMessage("ذكر"),
        "maleOnly": MessageLookupByLibrary.simpleMessage("رجال"),
        "manageAvailability":
            MessageLookupByLibrary.simpleMessage("أوقات العمل والتوفر"),
        "manageWorkingHours":
            MessageLookupByLibrary.simpleMessage("إدارة أوقات العمل"),
        "minExperienceYears": MessageLookupByLibrary.simpleMessage("الخبرة"),
        "minimumRating":
            MessageLookupByLibrary.simpleMessage("الحد الأدنى للتقييم"),
        "minutesDuration": m18,
        "monthlyPackageType":
            MessageLookupByLibrary.simpleMessage("باقة شهرية"),
        "monthlyPlanSummaryTitle":
            MessageLookupByLibrary.simpleMessage("ملخص الباقة الشهرية"),
        "monthlyPriceChip": m19,
        "monthlyPriceUSD":
            MessageLookupByLibrary.simpleMessage("سعر الباقة الشهرية (\$ USD)"),
        "monthlyPriceUSDDesc": MessageLookupByLibrary.simpleMessage(
            "سعر الاشتراك الشهري الكامل بالدولار الأمريكي"),
        "monthlyPriceUSDHint":
            MessageLookupByLibrary.simpleMessage("مثال: 200"),
        "monthlyPricingOptionDesc": MessageLookupByLibrary.simpleMessage(
            "خطة تدريب ومتابعة وتوجيه متواصل على مدار الشهر"),
        "monthlyPricingOptionTitle":
            MessageLookupByLibrary.simpleMessage("باقة شهرية"),
        "monthlyScheduleNotesHint": MessageLookupByLibrary.simpleMessage(
            "مثال: المواعيد المسائية حوالي 6، التركيز على بناء القوة"),
        "monthlyScheduleNotesLabel":
            MessageLookupByLibrary.simpleMessage("المواعيد المفضلة والأهداف"),
        "monthlySessionsProgress": m20,
        "myBookings":
            MessageLookupByLibrary.simpleMessage("جلسات وطلبات التدريب"),
        "nationalIdHint": MessageLookupByLibrary.simpleMessage(
            "ارفع صورة واضحة أو ملف PDF للهوية أو الجواز"),
        "nationalIdOrPassport": MessageLookupByLibrary.simpleMessage(
            "الهوية الوطنية أو جواز السفر"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "nextSessionTitle":
            MessageLookupByLibrary.simpleMessage("الجلسة القادمة"),
        "noAvailabilityListed": MessageLookupByLibrary.simpleMessage(
            "لم يتم تحديد أوقات ثابتة. يمكنك التنسيق عند الطلب."),
        "noAvailableSlotsForDate": MessageLookupByLibrary.simpleMessage(
            "لا توجد مواعيد متاحة في هذا اليوم"),
        "noAvailableSlotsForDay": MessageLookupByLibrary.simpleMessage(
            "لا توجد أوقات متاحة في هذا اليوم"),
        "noCoachesFound":
            MessageLookupByLibrary.simpleMessage("لم يتم العثور على مدربين"),
        "noCoachesFoundDesc": MessageLookupByLibrary.simpleMessage(
            "حاول تعديل البحث أو الفلاتر للعثور على مدربين متاحين."),
        "noConfirmedSessionsDesc": MessageLookupByLibrary.simpleMessage(
            "الجلسات التي قمت بقبولها ستظهر هنا."),
        "noConfirmedSessionsTitle":
            MessageLookupByLibrary.simpleMessage("لا توجد جلسات مؤكدة"),
        "noDaysSelected":
            MessageLookupByLibrary.simpleMessage("لم يتم تحديد أي أيام"),
        "noPastSessionsDesc": MessageLookupByLibrary.simpleMessage(
            "سيتم أرشفة الجلسات المكتملة والمرفوضة هنا."),
        "noPastSessionsTitle":
            MessageLookupByLibrary.simpleMessage("لا توجد جلسات سابقة"),
        "noPendingRequestsDesc": MessageLookupByLibrary.simpleMessage(
            "ستظهر طلبات المتدربين الجديدة هنا فور وصولها."),
        "noPendingRequestsPreview":
            MessageLookupByLibrary.simpleMessage("لا توجد طلبات معلقة حالياً"),
        "noPendingRequestsTitle":
            MessageLookupByLibrary.simpleMessage("لا توجد طلبات معلقة"),
        "noProfileData": MessageLookupByLibrary.simpleMessage(
            "لم يتم العثور على معلومات الملف الشخصي"),
        "noReviewsYet": MessageLookupByLibrary.simpleMessage("جديد"),
        "noSportsSelected":
            MessageLookupByLibrary.simpleMessage("لم يتم تحديد أي رياضة"),
        "noUpcomingSessionsDesc": MessageLookupByLibrary.simpleMessage(
            "حدد مواعيد توفرك ليتمكن المتدربون من حجز جلسات معك."),
        "noUpcomingSessionsTitle":
            MessageLookupByLibrary.simpleMessage("لا توجد جلسات قادمة"),
        "notSpecified": MessageLookupByLibrary.simpleMessage("غير محدد"),
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
        "oneMonthDuration": MessageLookupByLibrary.simpleMessage("شهر واحد"),
        "oneOnOneTraining":
            MessageLookupByLibrary.simpleMessage("تدريب فردي خاص 1 على 1"),
        "orContinueWith":
            MessageLookupByLibrary.simpleMessage("أو المتابعة عبر"),
        "originalTimeLabel":
            MessageLookupByLibrary.simpleMessage("الموعد الأصلي"),
        "otpVerification": MessageLookupByLibrary.simpleMessage("رمز التحقق"),
        "otpVerificationSubtitle": m21,
        "packageStartDateLabel":
            MessageLookupByLibrary.simpleMessage("تاريخ البدء"),
        "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
        "passwordLengthHint":
            MessageLookupByLibrary.simpleMessage("6 أحرف على الأقل"),
        "passwordMinLength": MessageLookupByLibrary.simpleMessage(
            "يجب ألا تقل كلمة المرور عن 6 أحرف"),
        "pastSessionsTab": MessageLookupByLibrary.simpleMessage("السجل"),
        "pdfDocument": MessageLookupByLibrary.simpleMessage("مستند PDF"),
        "pdfUploaded":
            MessageLookupByLibrary.simpleMessage("تم اختيار مستند PDF"),
        "pendingRequests": MessageLookupByLibrary.simpleMessage("طلبات معلقة"),
        "pendingRequestsPreview":
            MessageLookupByLibrary.simpleMessage("طلبات معلقة"),
        "perMonthUnit": MessageLookupByLibrary.simpleMessage("/ شهرياً"),
        "perSessionUnit": MessageLookupByLibrary.simpleMessage("/ جلسة"),
        "personalInfo":
            MessageLookupByLibrary.simpleMessage("المعلومات الشخصية"),
        "phoneAuthFailed": MessageLookupByLibrary.simpleMessage(
            "فشل التحقق. يرجى المحاولة مرة أخرى."),
        "phoneHint": MessageLookupByLibrary.simpleMessage("+966 50 123 4567"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
        "phoneSignInSubtitle": MessageLookupByLibrary.simpleMessage(
            "أدخل رقم هاتفك المحمول لتلقي رمز التحقق"),
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
        "pleaseSelectStartDate":
            MessageLookupByLibrary.simpleMessage("يرجى تحديد تاريخ البدء"),
        "pleaseSelectTimeSlot": MessageLookupByLibrary.simpleMessage(
            "يرجى تحديد وقت الجلسة للمتابعة"),
        "preferNotToSay":
            MessageLookupByLibrary.simpleMessage("أفضل عدم التحديد"),
        "pricePerSession":
            MessageLookupByLibrary.simpleMessage("سعر الجلسة الواحدة"),
        "pricePerSessionHint":
            MessageLookupByLibrary.simpleMessage("مثال: 150"),
        "priceRange": MessageLookupByLibrary.simpleMessage("نطاق السعر"),
        "priceUsdFormat": m22,
        "pricingStepSubtitle": MessageLookupByLibrary.simpleMessage(
            "حدد سعر جلسة التدريب والعملة المفضلة لديك"),
        "pricingTipText":
            MessageLookupByLibrary.simpleMessage("حدد سعراً للجلسة الواحدة."),
        "pricingTitle":
            MessageLookupByLibrary.simpleMessage("سعر ساعة التدريب"),
        "proposedTimeLabel":
            MessageLookupByLibrary.simpleMessage("الموعد المقترح"),
        "quickActionAvailability":
            MessageLookupByLibrary.simpleMessage("إدارة المواعيد"),
        "quickActionAvailabilityDesc":
            MessageLookupByLibrary.simpleMessage("تحديد ساعات وأيام العمل"),
        "quickActionBookings":
            MessageLookupByLibrary.simpleMessage("عرض الحجوزات"),
        "quickActionBookingsDesc":
            MessageLookupByLibrary.simpleMessage("الطلبات والمؤكدة والسجل"),
        "quickActions": MessageLookupByLibrary.simpleMessage("إجراءات سريعة"),
        "quickAvailabilityTemplates": MessageLookupByLibrary.simpleMessage(
            "نماذج سريعة للمواعيد المتاحة"),
        "rejectReasonFullyBooked":
            MessageLookupByLibrary.simpleMessage("جدول المواعيد ممتلئ"),
        "rejectReasonOther": MessageLookupByLibrary.simpleMessage("سبب آخر"),
        "rejectReasonOutsideHours":
            MessageLookupByLibrary.simpleMessage("خارج أوقات العمل"),
        "rejectReasonScheduleConflict":
            MessageLookupByLibrary.simpleMessage("تعارض في المواعيد"),
        "rejectRequest": MessageLookupByLibrary.simpleMessage("رفض"),
        "rejectRequestDialogDesc": m23,
        "rejectRequestDialogTitle":
            MessageLookupByLibrary.simpleMessage("رفض طلب التدريب"),
        "rejectionNotesHint": MessageLookupByLibrary.simpleMessage(
            "أضف تفاصيل أو توضيح (اختياري)..."),
        "rejectionNotesRequiredHint": MessageLookupByLibrary.simpleMessage(
            "يرجى كتابة تفاصيل سبب الرفض..."),
        "rejectionReasonHint": MessageLookupByLibrary.simpleMessage(
            "مثال: تعارض في المواعيد، خارج النادي، إلخ."),
        "rejectionReasonLabel":
            MessageLookupByLibrary.simpleMessage("ملاحظات فريق الإدارة:"),
        "rejectionReasonOptional":
            MessageLookupByLibrary.simpleMessage("سبب الرفض (اختياري)"),
        "removeDocument": MessageLookupByLibrary.simpleMessage("حذف المستند"),
        "removePhoto": MessageLookupByLibrary.simpleMessage("إزالة الصورة"),
        "replaceFile": MessageLookupByLibrary.simpleMessage("استبدال المستند"),
        "requestAcceptedSuccess":
            MessageLookupByLibrary.simpleMessage("تم تأكيد طلب التدريب بنجاح!"),
        "requestRejectedSuccess":
            MessageLookupByLibrary.simpleMessage("تم رفض طلب التدريب."),
        "requestTraining":
            MessageLookupByLibrary.simpleMessage("طلب جلسة تدريب"),
        "requiredBadge": MessageLookupByLibrary.simpleMessage("مطلوب"),
        "rescheduleAcceptedSuccess":
            MessageLookupByLibrary.simpleMessage("تم تحديث موعد الجلسة بنجاح!"),
        "rescheduleAction": MessageLookupByLibrary.simpleMessage("إعادة جدولة"),
        "rescheduleDeclinedMessage": MessageLookupByLibrary.simpleMessage(
            "تم إلغاء الحجز. يمكنك حجز جلسة جديدة في أي وقت."),
        "reschedulePendingBadge":
            MessageLookupByLibrary.simpleMessage("بانتظار موافقة المتدرب"),
        "rescheduleReasonHint": MessageLookupByLibrary.simpleMessage(
            "وضح سبب إعادة الجدولة (ظرف طارئ، مرض...)"),
        "rescheduleReasonLabel":
            MessageLookupByLibrary.simpleMessage("سبب إعادة الجدولة"),
        "rescheduleReasonRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى كتابة سبب إعادة الجدولة"),
        "rescheduleRequestedSuccess": MessageLookupByLibrary.simpleMessage(
            "تم إرسال طلب إعادة الجدولة إلى المتدرب"),
        "rescheduleSession":
            MessageLookupByLibrary.simpleMessage("إعادة جدولة الجلسة"),
        "resend": MessageLookupByLibrary.simpleMessage("إعادة الإرسال"),
        "resendCode": MessageLookupByLibrary.simpleMessage("إعادة إرسال الرمز"),
        "resendCodeIn": m24,
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
        "reviewFilesAttached": m25,
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
        "reviewYearsCount": m26,
        "reviewsCount": m27,
        "role": MessageLookupByLibrary.simpleMessage("الدور"),
        "saveAvailability":
            MessageLookupByLibrary.simpleMessage("حفظ جدول التوفر"),
        "savingAvailability":
            MessageLookupByLibrary.simpleMessage("جارٍ الحفظ..."),
        "scheduleAndAvailability":
            MessageLookupByLibrary.simpleMessage("الجدول والمواعيد الأسبوعية"),
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
        "selectPackageStartDate":
            MessageLookupByLibrary.simpleMessage("اختر تاريخ بدء الاشتراك"),
        "selectRejectionReasonLabel":
            MessageLookupByLibrary.simpleMessage("اختر سبب الرفض:"),
        "selectRequiredSessionsPrompt": m28,
        "selectSportsSubtitle": MessageLookupByLibrary.simpleMessage(
            "اختر رياضة واحدة أو أكثر ترغب في التدرب عليها"),
        "selectSportsYouCoach":
            MessageLookupByLibrary.simpleMessage("اختر الرياضات التي تدربها"),
        "selectTrainingDate":
            MessageLookupByLibrary.simpleMessage("اختر التاريخ"),
        "selectTrainingSport":
            MessageLookupByLibrary.simpleMessage("اختر الرياضة"),
        "selectTrainingTime":
            MessageLookupByLibrary.simpleMessage("اختر وقت الجلسة"),
        "selectedDateLabel": MessageLookupByLibrary.simpleMessage("التاريخ"),
        "selectedSessionsListTitle": m29,
        "selectedSportLabel": MessageLookupByLibrary.simpleMessage("الرياضة"),
        "selectedTimeLabel": MessageLookupByLibrary.simpleMessage("الوقت"),
        "sendOtp": MessageLookupByLibrary.simpleMessage("إرسال رمز التحقق"),
        "sendRescheduleRequest":
            MessageLookupByLibrary.simpleMessage("إرسال طلب إعادة الجدولة"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("إرسال رابط التعيين"),
        "sessionCountdownDays": m30,
        "sessionCountdownHours": m31,
        "sessionCountdownToday": MessageLookupByLibrary.simpleMessage("اليوم"),
        "sessionDeclineReason": m32,
        "sessionDuration": MessageLookupByLibrary.simpleMessage("مدة الجلسة"),
        "sessionHistory": MessageLookupByLibrary.simpleMessage("سجل الجلسات"),
        "sessionNumberLabel": m33,
        "sessionPassed": MessageLookupByLibrary.simpleMessage("انتهت"),
        "sessionPriceChip": m34,
        "sessionPricing": MessageLookupByLibrary.simpleMessage("سعر الجلسة"),
        "sessionPricingOptionDesc": MessageLookupByLibrary.simpleMessage(
            "تمرين مباشر مخصص 1 على 1 مع الكابتن"),
        "sessionPricingOptionTitle":
            MessageLookupByLibrary.simpleMessage("جلسة فردية"),
        "sessionWith": m35,
        "sessionsSelectedCount": m36,
        "setAvailabilityButton":
            MessageLookupByLibrary.simpleMessage("تحديد المواعيد"),
        "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "سجل دخولك للوصول إلى منصتك الرياضية"),
        "signInWithPhone":
            MessageLookupByLibrary.simpleMessage("تسجيل الدخول برقم الهاتف"),
        "signOut": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
        "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
        "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
            "انضم إلى كوتش هاب وابدأ رحلتك اليوم"),
        "singleSessionPriceUSD":
            MessageLookupByLibrary.simpleMessage("سعر الجلسة الواحدة (\$ USD)"),
        "singleSessionPriceUSDDesc": MessageLookupByLibrary.simpleMessage(
            "سعر الحصة الواحدة بالدولار الأمريكي"),
        "singleSessionPriceUSDHint":
            MessageLookupByLibrary.simpleMessage("مثال: 50"),
        "singleSessionType": MessageLookupByLibrary.simpleMessage("جلسة فردية"),
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
        "sportsSelected": m37,
        "startExploringCoaches":
            MessageLookupByLibrary.simpleMessage("ابدأ استكشاف المدربين"),
        "startTime": MessageLookupByLibrary.simpleMessage("وقت البدء"),
        "statHistory": MessageLookupByLibrary.simpleMessage("السجل"),
        "statPending": MessageLookupByLibrary.simpleMessage("معلقة"),
        "statUpcoming": MessageLookupByLibrary.simpleMessage("قادمة"),
        "statusCancelled": MessageLookupByLibrary.simpleMessage("ملغاة"),
        "statusCompleted": MessageLookupByLibrary.simpleMessage("مكتملة"),
        "statusConfirmed": MessageLookupByLibrary.simpleMessage("مؤكدة"),
        "statusDeclined": MessageLookupByLibrary.simpleMessage("مرفوضة"),
        "stepAvailability":
            MessageLookupByLibrary.simpleMessage("المواعيد الأسبوعية"),
        "stepOf": m38,
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
        "submittingBookingRequest":
            MessageLookupByLibrary.simpleMessage("جارٍ إرسال الطلب..."),
        "success": MessageLookupByLibrary.simpleMessage("نجاح"),
        "summaryConfirmedSessions": m39,
        "summaryPastSessions": m40,
        "summaryPendingRequests": m41,
        "supportEmail":
            MessageLookupByLibrary.simpleMessage("alitoson1234567@gmail.com"),
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
        "thisMonthEarnings":
            MessageLookupByLibrary.simpleMessage("أرباح هذا الشهر"),
        "thisWeekSchedule":
            MessageLookupByLibrary.simpleMessage("جدول هذا الأسبوع"),
        "timeSlots": MessageLookupByLibrary.simpleMessage("ساعات العمل"),
        "toTime": MessageLookupByLibrary.simpleMessage("إلى"),
        "totalDurationLabel": m42,
        "totalMonthlyPrice":
            MessageLookupByLibrary.simpleMessage("سعر الباقة الشهرية"),
        "totalSessionPrice": MessageLookupByLibrary.simpleMessage("سعر الجلسة"),
        "trainee": MessageLookupByLibrary.simpleMessage("متدرب"),
        "traineeDesc": MessageLookupByLibrary.simpleMessage(
            "ابحث عن مدربين محترفين، احجز جلسات تدريبية، وحقق أهدافك الرياضية."),
        "traineeDiscovery":
            MessageLookupByLibrary.simpleMessage("استكشاف المدربين"),
        "traineeMarketplacePlaceholder":
            MessageLookupByLibrary.simpleMessage("شاشة المتدرب (المرحلة 3)"),
        "traineeNavDiscovery":
            MessageLookupByLibrary.simpleMessage("الاستكشاف"),
        "traineeNavProfile":
            MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
        "traineeNotes": MessageLookupByLibrary.simpleMessage("ملاحظات المتدرب"),
        "traineeProfileTitle":
            MessageLookupByLibrary.simpleMessage("ملفي الشخصي"),
        "traineeSetup": MessageLookupByLibrary.simpleMessage("إعداد المتدرب"),
        "traineeSetupSubtitle": MessageLookupByLibrary.simpleMessage(
            "أنشئ ملفك الشخصي للمتدرب وابدأ رحلتك الرياضية"),
        "tryAgain": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
        "unavailable": MessageLookupByLibrary.simpleMessage("غير متاح"),
        "underReviewNotice": MessageLookupByLibrary.simpleMessage(
            "طلبك حالياً في وضع القراءة فقط أثناء المراجعة. سيتم إشعارك فور اتخاذ القرار."),
        "upcomingSessions": MessageLookupByLibrary.simpleMessage("جلسات قادمة"),
        "uploadDocument": MessageLookupByLibrary.simpleMessage("رفع المستند"),
        "uploadFailed": MessageLookupByLibrary.simpleMessage(
            "فشل الرفع، يرجى المحاولة مرة أخرى لاحقاً"),
        "uploading": MessageLookupByLibrary.simpleMessage("جاري الرفع..."),
        "uploadingPhoto":
            MessageLookupByLibrary.simpleMessage("جاري رفع الصورة..."),
        "usdBadge": MessageLookupByLibrary.simpleMessage("USD"),
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
        "validationMonthlyPriceRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى تحديد سعر صالح للباقة الشهرية أكبر من 0."),
        "validationNameRequired":
            MessageLookupByLibrary.simpleMessage("يرجى إدخال اسمك الكامل."),
        "validationPhotoRequired":
            MessageLookupByLibrary.simpleMessage("يرجى رفع صورة شخصية."),
        "validationRateRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى إدخال سعر صحيح لجلسة التدريب."),
        "validationSessionPriceRequired": MessageLookupByLibrary.simpleMessage(
            "يرجى تحديد سعر صالح للجلسة الواحدة أكبر من 0."),
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
        "verifyAndContinue":
            MessageLookupByLibrary.simpleMessage("تحقق ومتابعة"),
        "viewAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
        "viewCertificate": MessageLookupByLibrary.simpleMessage("عرض الشهادة"),
        "viewProfile": MessageLookupByLibrary.simpleMessage("عرض الملف الشخصي"),
        "warning": MessageLookupByLibrary.simpleMessage("تنبيه"),
        "weeklyAvailabilityTitle":
            MessageLookupByLibrary.simpleMessage("أوقات التوفر الأسبوعية"),
        "weeklyFrequencyLabel":
            MessageLookupByLibrary.simpleMessage("عدد التدريبات الأسبوعية"),
        "weightLoss": MessageLookupByLibrary.simpleMessage("خسارة الوزن"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("مرحباً بعودتك"),
        "welcomeBackUser": m43,
        "whatsIncluded":
            MessageLookupByLibrary.simpleMessage("ما تشمله الجلسة"),
        "workingDays": MessageLookupByLibrary.simpleMessage("أيام العمل"),
        "workingHoursDescription": MessageLookupByLibrary.simpleMessage(
            "تحديد أوقات وأيام التدريب الأسبوعية"),
        "yearsOfExperience":
            MessageLookupByLibrary.simpleMessage("سنوات الخبرة في التدريب"),
        "yourGoal": MessageLookupByLibrary.simpleMessage("هدفك التدريبي"),
        "yourLevel": MessageLookupByLibrary.simpleMessage("مستواك الرياضي"),
        "yourProfile": MessageLookupByLibrary.simpleMessage("ملفك الشخصي"),
        "yourSports": MessageLookupByLibrary.simpleMessage("رياضاتك المفضلة")
      };
}
