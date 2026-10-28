import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_setup_cert_helper.dart';
import 'coach_setup_draft_helper.dart';
import 'coach_setup_states.dart';
import 'coach_setup_submit_helper.dart';
import 'coach_setup_validator.dart';

class CoachSetupCubit extends Cubit<CoachSetupState> {
  final CoachSetupRepo repository;

  int currentStep = 0;
  String photoUrl = '', name = '', bio = '', country = '', city = '', gender = '';
  int age = 0, yearsOfExperience = 1;
  List<String> selectedLanguages = ['Arabic'], selectedSports = [], specialties = [];
  double sessionPriceUSD = 0.0, monthlyPriceUSD = 0.0;
  String currency = 'USD';
  String availabilitySummary = 'Mon, Tue, Wed, Thu, Fri (05:00 PM - 09:00 PM)';
  List<DayAvailability> weeklyAvailability = DayAvailability.defaultSchedule();
  String identityDocumentUrl = '';
  List<String> certificateUrls = [];

  double get sessionPrice => sessionPriceUSD;
  set sessionPrice(double val) => sessionPriceUSD = val;

  CoachSetupCubit({required this.repository})
      : super(const CoachSetupInitialState()) {
    _emitCurrentForm();
  }

  void _emitCurrentForm([String? error]) {
    emit(CoachSetupFormUpdatedState.fromCubit(this, error));
    _saveDraft();
  }

  void setPhotoUrl(String val) { photoUrl = val; _emitCurrentForm(); }
  void setName(String val) { name = val; _emitCurrentForm(); }
  void setBio(String val) { bio = val; _emitCurrentForm(); }
  void setCountry(String val) { country = val; city = ''; _emitCurrentForm(); }
  void setCity(String val) { city = val; _emitCurrentForm(); }
  void setAge(int val) { age = val; _emitCurrentForm(); }
  void setGender(String val) { gender = val; _emitCurrentForm(); }
  void setExperience(int yrs) { yearsOfExperience = yrs; _emitCurrentForm(); }
  void setSessionPrice(double rate) { sessionPriceUSD = rate; _emitCurrentForm(); }
  void setMonthlyPrice(double rate) { monthlyPriceUSD = rate; _emitCurrentForm(); }
  void setCurrency(String val) { currency = 'USD'; _emitCurrentForm(); }
  void setAvailability(String val) { availabilitySummary = val; _emitCurrentForm(); }
  void setIdentityDocument(String url) { identityDocumentUrl = url; _emitCurrentForm(); }
  void setSpecialties(List<String> list) { specialties = list; _emitCurrentForm(); }

  void setWeeklyAvailability(List<DayAvailability> sched, String summary) {
    weeklyAvailability = sched;
    availabilitySummary = summary;
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
    certificateUrls = CoachSetupCertHelper.add(certificateUrls, url);
    _emitCurrentForm();
  }

  void updateCertificate(int index, String url) {
    certificateUrls = CoachSetupCertHelper.update(certificateUrls, index, url);
    _emitCurrentForm();
  }

  void removeCertificate(int index) {
    certificateUrls = CoachSetupCertHelper.remove(certificateUrls, index);
    _emitCurrentForm();
  }

  bool validateStep(int step) {
    final err = CoachSetupValidator.validateCubit(step, this);
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
    await CoachSetupSubmitHelper.submit(
      repository: repository,
      cubit: this,
      emit: emit,
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
    return CoachSetupSubmitHelper.loadDraftOrPrevious(
      repository: repository,
      cubit: this,
      prevProfile: prevProfile,
      prevApp: prevApp,
      onLoaded: _emitCurrentForm,
    );
  }
}
