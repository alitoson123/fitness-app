import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_setup_draft_helper.dart';
import 'coach_setup_states.dart';
import 'coach_setup_validator.dart';

class CoachSetupCubit extends Cubit<CoachSetupState> {
  final CoachSetupRepo repository;

  int currentStep = 0;
  String photoUrl = '';
  String name = '';
  String bio = '';
  String country = '';
  String city = '';
  int age = 0;
  String gender = '';
  List<String> selectedLanguages = ['Arabic'];
  List<String> selectedSports = [];
  List<String> specialties = [];
  int yearsOfExperience = 1;
  double sessionPrice = 0.0;
  String currency = 'USD';
  String availabilitySummary = 'Mon, Tue, Wed, Thu, Fri (05:00 PM - 09:00 PM)';
  List<DayAvailability> weeklyAvailability = DayAvailability.defaultSchedule();
  String identityDocumentUrl = '';
  List<String> certificateUrls = [];

  CoachSetupCubit({required this.repository})
    : super(const CoachSetupInitialState()) {
    _emitCurrentForm();
  }

  void _emitCurrentForm([String? error]) {
    emit(
      CoachSetupFormUpdatedState(
        currentStep: currentStep,
        photoUrl: photoUrl,
        name: name,
        bio: bio,
        country: country,
        city: city,
        age: age,
        gender: gender,
        selectedLanguages: List.unmodifiable(selectedLanguages),
        selectedSports: List.unmodifiable(selectedSports),
        specialties: List.unmodifiable(specialties),
        yearsOfExperience: yearsOfExperience,
        sessionPrice: sessionPrice,
        currency: currency,
        availabilitySummary: availabilitySummary,
        identityDocumentUrl: identityDocumentUrl,
        certificateUrls: List.unmodifiable(certificateUrls),
        validationError: error,
      ),
    );
    _saveDraft();
  }

  void setPhotoUrl(String url) {
    photoUrl = url;
    _emitCurrentForm();
  }

  void setName(String val) {
    name = val;
    _emitCurrentForm();
  }

  void setBio(String val) {
    bio = val;
    _emitCurrentForm();
  }

  void setCountry(String val) {
    country = val;
    city = '';
    _emitCurrentForm();
  }

  void setCity(String val) {
    city = val;
    _emitCurrentForm();
  }

  void setAge(int val) {
    age = val;
    _emitCurrentForm();
  }

  void setGender(String val) {
    gender = val;
    _emitCurrentForm();
  }

  void setExperience(int yrs) {
    yearsOfExperience = yrs;
    _emitCurrentForm();
  }

  void setSessionPrice(double rate) {
    sessionPrice = rate;
    _emitCurrentForm();
  }

  void setCurrency(String val) {
    currency = val;
    _emitCurrentForm();
  }

  void setAvailability(String val) {
    availabilitySummary = val;
    _emitCurrentForm();
  }

  void setWeeklyAvailability(
    List<DayAvailability> schedule,
    String summary,
  ) {
    weeklyAvailability = schedule;
    availabilitySummary = summary;
    _emitCurrentForm();
  }

  void setIdentityDocument(String url) {
    identityDocumentUrl = url;
    _emitCurrentForm();
  }

  void setSpecialties(List<String> list) {
    specialties = list;
    _emitCurrentForm();
  }

  void toggleLanguage(String lang) {
    final list = List<String>.from(selectedLanguages);
    list.contains(lang) ? list.remove(lang) : list.add(lang);
    selectedLanguages = list;
    _emitCurrentForm();
  }

  void toggleSport(String sport) {
    final list = List<String>.from(selectedSports);
    list.contains(sport) ? list.remove(sport) : list.add(sport);
    selectedSports = list;
    _emitCurrentForm();
  }

  void addCertificate(String url) {
    certificateUrls = List<String>.from(certificateUrls)..add(url);
    _emitCurrentForm();
  }

  void updateCertificate(int index, String url) {
    if (index >= 0 && index < certificateUrls.length) {
      final list = List<String>.from(certificateUrls);
      list[index] = url;
      certificateUrls = list;
      _emitCurrentForm();
    }
  }

  void removeCertificate(int index) {
    if (index >= 0 && index < certificateUrls.length) {
      final list = List<String>.from(certificateUrls)..removeAt(index);
      if (list.length == 1 && list.first.isEmpty) {
        certificateUrls = [];
      } else {
        certificateUrls = list;
      }
      _emitCurrentForm();
    }
  }

  bool validateStep(int step) {
    final err = CoachSetupValidator.validateStep(
      step: step,
      photoUrl: photoUrl,
      name: name,
      country: country,
      city: city,
      age: age,
      gender: gender,
      bio: bio,
      selectedLanguages: selectedLanguages,
      selectedSports: selectedSports,
      hourlyRate: sessionPrice,
      availabilitySummary: availabilitySummary,
      identityDocumentUrl: identityDocumentUrl,
      certificateUrls: certificateUrls,
    );
    if (err != null) {
      _emitCurrentForm(err);
      return false;
    }
    return true;
  }

  void nextStep() {
    if (!validateStep(currentStep)) return;
    if (currentStep < 5) {
      currentStep++;
      _emitCurrentForm();
    } else {
      submitApplication();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      _emitCurrentForm();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 5) {
      currentStep = step;
      _emitCurrentForm();
    }
  }

  Future<void> submitApplication() async {
    for (int i = 0; i <= 4; i++) {
      if (!validateStep(i)) {
        currentStep = i;
        return;
      }
    }
    emit(const CoachSetupLoadingState());
    final profile = CoachSetupDraftHelper.buildProfile(this);
    final application = CoachSetupDraftHelper.buildApplication(this);

    final result = await repository.submitCoachApplication(
      profile: profile,
      application: application,
    );
    result.fold(
      (failure) =>
          emit(CoachSetupErrorState(errorMessage: failure.errorMessage)),
      (_) => emit(const CoachSetupSuccessState()),
    );
  }

  Future<void> _saveDraft() async {
    await repository.saveDraftApplication(
      draftData: CoachSetupDraftHelper.toDraftMap(this),
    );
  }

  Future<bool> loadDraftOrPrevious(
    CoachProfileModel? prevProfile,
    CoachApplicationModel? prevApp,
  ) async {
    if (prevProfile != null) {
      name = prevProfile.name;
      photoUrl = prevProfile.photoUrl;
      bio = prevProfile.bio;
      country = prevProfile.country;
      city = prevProfile.city;
      age = prevProfile.age;
      gender = prevProfile.gender.isNotEmpty ? prevProfile.gender : 'male';
      selectedLanguages = prevProfile.languages;
      selectedSports = prevProfile.sports;
      specialties = prevProfile.specialties;
      yearsOfExperience = prevProfile.yearsOfExperience;
      sessionPrice = prevProfile.sessionPrice;
      currency = prevProfile.currency;
      availabilitySummary = prevProfile.availabilitySummary;
      if (prevApp != null) {
        identityDocumentUrl = prevApp.identityDocumentUrl;
        certificateUrls = prevApp.certificateUrls;
      }
      _emitCurrentForm();
      return true;
    }

    final draftRes = await repository.getDraftApplication();
    return draftRes.fold((_) => false, (data) {
      if (data == null) return false;
      currentStep = data['step'] as int? ?? 0;
      photoUrl = data['photoUrl'] as String? ?? '';
      name = data['name'] as String? ?? '';
      bio = data['bio'] as String? ?? '';
      country = data['country'] as String? ?? '';
      city = data['city'] as String? ?? '';
      age = data['age'] as int? ?? 0;
      gender = data['gender'] as String? ?? 'male';
      selectedLanguages =
          (data['selectedLanguages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Arabic'];
      selectedSports =
          (data['selectedSports'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      specialties =
          (data['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      yearsOfExperience = data['yearsOfExperience'] as int? ?? 1;
      sessionPrice = (data['hourlyRate'] as num?)?.toDouble() ?? 0.0;
      currency = data['currency'] as String? ?? 'SAR';
      availabilitySummary = data['availabilitySummary'] as String? ?? '';
      if (data['weeklyAvailability'] != null) {
        final list = data['weeklyAvailability'] as List<dynamic>;
        weeklyAvailability = list
            .map((e) =>
                DayAvailability.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      identityDocumentUrl = data['identityDocumentUrl'] as String? ?? '';
      certificateUrls =
          (data['certificateUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      _emitCurrentForm();
      return true;
    });
  }
}
