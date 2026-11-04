import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/sport_location_model.dart';
import 'package:fitness_app/features/coach_setup/domain/repo/coach_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_setup_cert_helper.dart';
import 'coach_setup_draft_helper.dart';
import 'coach_setup_location_helper.dart';
import 'coach_setup_nav_helper.dart';
import 'coach_setup_states.dart';
import 'coach_setup_submit_helper.dart';

class CoachSetupCubit extends Cubit<CoachSetupState> {
  final CoachSetupRepo repository;
  int currentStep = 0;
  String photoUrl = '', name = '', bio = '', country = '', city = '', gender = '';
  int age = 0, yearsOfExperience = 1;
  List<String> selectedLanguages = ['Arabic'], selectedSports = [], specialties = [];
  List<SportLocationModel> sportLocations = [];
  double sessionPriceUSD = 0.0, monthlyPriceUSD = 0.0;
  String currency = 'USD';
  String availabilitySummary = 'Mon, Tue, Wed, Thu, Fri (05:00 PM - 09:00 PM)';
  List<DayAvailability> weeklyAvailability = DayAvailability.defaultSchedule();
  String identityDocumentUrl = '';
  List<String> certificateUrls = [];

  CoachSetupCubit({required this.repository}) : super(const CoachSetupInitialState()) {
    emitCurrentForm();
  }

  void emitCurrentForm([String? error]) {
    emit(CoachSetupFormUpdatedState.fromCubit(this, error));
    _saveDraft();
  }

  void setPhotoUrl(String val) { photoUrl = val; emitCurrentForm(); }
  void setName(String val) { name = val; emitCurrentForm(); }
  void setBio(String val) { bio = val; emitCurrentForm(); }
  void setCountry(String val) { country = val; city = ''; emitCurrentForm(); }
  void setCity(String val) { city = val; emitCurrentForm(); }
  void setAge(int val) { age = val; emitCurrentForm(); }
  void setGender(String val) { gender = val; emitCurrentForm(); }
  void setExperience(int yrs) { yearsOfExperience = yrs; emitCurrentForm(); }
  void setSessionPrice(double rate) { sessionPriceUSD = rate; emitCurrentForm(); }
  void setMonthlyPrice(double rate) { monthlyPriceUSD = rate; emitCurrentForm(); }
  void setCurrency(String val) { currency = 'USD'; emitCurrentForm(); }
  void setAvailability(String val) { availabilitySummary = val; emitCurrentForm(); }
  void setIdentityDocument(String url) { identityDocumentUrl = url; emitCurrentForm(); }
  void setSpecialties(List<String> list) { specialties = list; emitCurrentForm(); }
  void setWeeklyAvailability(List<DayAvailability> s, String sum) {
    weeklyAvailability = s;
    availabilitySummary = sum;
    emitCurrentForm();
  }

  void toggleLanguage(String lang) {
    final list = List<String>.from(selectedLanguages);
    list.contains(lang) ? list.remove(lang) : list.add(lang);
    selectedLanguages = list;
    emitCurrentForm();
  }

  void toggleSport(String sport) {
    final list = List<String>.from(selectedSports);
    final target = CoachSetupLocationHelper.normalize(sport);
    final index = list.indexWhere((s) => CoachSetupLocationHelper.normalize(s) == target);
    if (index >= 0) {
      list.removeAt(index);
      sportLocations = CoachSetupLocationHelper.syncOnRemoveSport(sportLocations, sport);
    } else {
      list.add(sport);
      sportLocations = CoachSetupLocationHelper.syncOnAddSport(sportLocations, sport);
    }
    selectedSports = list;
    emitCurrentForm();
  }

  void addCustomSport(String sport) {
    final trimmed = sport.trim();
    if (trimmed.isEmpty) return;
    final target = CoachSetupLocationHelper.normalize(trimmed);
    if (!selectedSports.any((s) => CoachSetupLocationHelper.normalize(s) == target)) {
      selectedSports = List<String>.from(selectedSports)..add(trimmed);
      sportLocations = CoachSetupLocationHelper.syncOnAddSport(sportLocations, trimmed);
      emitCurrentForm();
    }
  }

  void removeCustomSport(String sport) {
    final target = CoachSetupLocationHelper.normalize(sport);
    selectedSports = selectedSports.where((s) => CoachSetupLocationHelper.normalize(s) != target).toList();
    sportLocations = CoachSetupLocationHelper.syncOnRemoveSport(sportLocations, sport);
    emitCurrentForm();
  }

  void toggleSportOnline(String sport, bool isOnline) {
    sportLocations = CoachSetupLocationHelper.toggleOnline(sportLocations, sport, isOnline);
    emitCurrentForm();
  }

  void addSportLocation(String sport, String locationName) {
    sportLocations = CoachSetupLocationHelper.addLocation(sportLocations, sport, locationName);
    emitCurrentForm();
  }

  void removeSportLocation(String sport, int index) {
    sportLocations = CoachSetupLocationHelper.removeLocation(sportLocations, sport, index);
    emitCurrentForm();
  }

  void addCertificate(String u) { certificateUrls = CoachSetupCertHelper.add(certificateUrls, u); emitCurrentForm(); }
  void updateCertificate(int i, String u) { certificateUrls = CoachSetupCertHelper.update(certificateUrls, i, u); emitCurrentForm(); }
  void removeCertificate(int i) { certificateUrls = CoachSetupCertHelper.remove(certificateUrls, i); emitCurrentForm(); }

  bool validateStep(int step) => CoachSetupNavHelper.validateStep(this, step);
  void nextStep() => CoachSetupNavHelper.nextStep(this);
  void previousStep() => CoachSetupNavHelper.previousStep(this);
  void goToStep(int step) => CoachSetupNavHelper.goToStep(this, step);

  Future<void> submitApplication() async {
    await CoachSetupSubmitHelper.submit(repository: repository, cubit: this, emit: emit);
  }

  Future<void> _saveDraft() async {
    await repository.saveDraftApplication(draftData: CoachSetupDraftHelper.toDraftMap(this));
  }

  Future<bool> loadDraftOrPrevious(CoachProfileModel? profile, CoachApplicationModel? app) async {
    return CoachSetupSubmitHelper.loadDraftOrPrevious(
      repository: repository,
      cubit: this,
      prevProfile: profile,
      prevApp: app,
      onLoaded: emitCurrentForm,
    );
  }
}
