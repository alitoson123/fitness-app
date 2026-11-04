import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/sport_location_model.dart';
import 'coach_setup_cubit.dart';

class CoachSetupDraftHelper {
  static Map<String, dynamic> toDraftMap(CoachSetupCubit cubit) {
    return {
      'step': cubit.currentStep,
      'photoUrl': cubit.photoUrl,
      'name': cubit.name,
      'bio': cubit.bio,
      'country': cubit.country,
      'city': cubit.city,
      'age': cubit.age,
      'gender': cubit.gender,
      'selectedLanguages': cubit.selectedLanguages,
      'selectedSports': cubit.selectedSports,
      'sportLocations':
          cubit.sportLocations.map((e) => e.toMap()).toList(),
      'specialties': cubit.specialties,
      'yearsOfExperience': cubit.yearsOfExperience,
      'sessionPriceUSD': cubit.sessionPriceUSD,
      'monthlyPriceUSD': cubit.monthlyPriceUSD,
      'currency': 'USD',
      'availabilitySummary': cubit.availabilitySummary,
      'weeklyAvailability':
          cubit.weeklyAvailability.map((e) => e.toMap()).toList(),
      'identityDocumentUrl': cubit.identityDocumentUrl,
      'certificateUrls': cubit.certificateUrls,
    };
  }

  static CoachProfileModel buildProfile(CoachSetupCubit cubit) {
    return CoachProfileModel(
      uid: '',
      name: cubit.name.trim(),
      photoUrl: cubit.photoUrl,
      bio: cubit.bio.trim(),
      country: cubit.country,
      city: cubit.city,
      age: cubit.age,
      gender: cubit.gender,
      languages: cubit.selectedLanguages,
      sports: cubit.selectedSports,
      specialties: cubit.specialties,
      sportLocations: cubit.sportLocations,
      yearsOfExperience: cubit.yearsOfExperience,
      sessionPriceUSD: cubit.sessionPriceUSD,
      monthlyPriceUSD: cubit.monthlyPriceUSD,
      currency: 'USD',
      availabilitySummary: cubit.availabilitySummary.trim(),
      weeklyAvailability: cubit.weeklyAvailability,
      certificateUrls:
          cubit.certificateUrls.where((u) => u.isNotEmpty).toList(),
    );
  }

  static CoachApplicationModel buildApplication(CoachSetupCubit cubit) {
    return CoachApplicationModel(
      coachUid: '',
      status: 'pending',
      identityDocumentUrl: cubit.identityDocumentUrl,
      certificateUrls:
          cubit.certificateUrls.where((u) => u.isNotEmpty).toList(),
      submittedAt: DateTime.now(),
    );
  }

  static void applyProfile(
    CoachSetupCubit c,
    CoachProfileModel profile,
    CoachApplicationModel? app,
  ) {
    c.name = profile.name;
    c.photoUrl = profile.photoUrl;
    c.bio = profile.bio;
    c.country = profile.country;
    c.city = profile.city;
    c.age = profile.age;
    c.gender = profile.gender.isNotEmpty ? profile.gender : 'male';
    c.selectedLanguages = profile.languages;
    c.selectedSports = profile.sports;
    c.sportLocations = profile.sportLocations.isNotEmpty
        ? List.from(profile.sportLocations)
        : profile.sports.map((s) => SportLocationModel(sport: s, isOnline: true)).toList();
    c.specialties = profile.specialties;
    c.yearsOfExperience = profile.yearsOfExperience;
    c.sessionPriceUSD = profile.sessionPriceUSD;
    c.monthlyPriceUSD = profile.monthlyPriceUSD;
    c.currency = 'USD';
    c.availabilitySummary = profile.availabilitySummary;
    if (app != null) {
      c.identityDocumentUrl = app.identityDocumentUrl;
      c.certificateUrls = app.certificateUrls;
    }
  }

  static void applyDraft(CoachSetupCubit c, Map<String, dynamic> data) {
    c.currentStep = data['step'] as int? ?? 0;
    c.photoUrl = data['photoUrl'] as String? ?? '';
    c.name = data['name'] as String? ?? '';
    c.bio = data['bio'] as String? ?? '';
    c.country = data['country'] as String? ?? '';
    c.city = data['city'] as String? ?? '';
    c.age = data['age'] as int? ?? 0;
    c.gender = data['gender'] as String? ?? 'male';
    c.selectedLanguages = (data['selectedLanguages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['Arabic'];
    c.selectedSports = (data['selectedSports'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    if (data['sportLocations'] != null) {
      final list = data['sportLocations'] as List<dynamic>;
      c.sportLocations = list
          .whereType<Map>()
          .map((e) => SportLocationModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      c.sportLocations =
          c.selectedSports.map((s) => SportLocationModel(sport: s)).toList();
    }
    c.specialties = (data['specialties'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    c.yearsOfExperience = data['yearsOfExperience'] as int? ?? 1;
    c.sessionPriceUSD = (data['sessionPriceUSD'] as num?)?.toDouble() ?? 0.0;
    c.monthlyPriceUSD = (data['monthlyPriceUSD'] as num?)?.toDouble() ?? 0.0;
    c.currency = 'USD';
    c.availabilitySummary = data['availabilitySummary'] as String? ?? '';
    if (data['weeklyAvailability'] != null) {
      final list = data['weeklyAvailability'] as List<dynamic>;
      c.weeklyAvailability = list
          .map((e) =>
              DayAvailability.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    c.identityDocumentUrl = data['identityDocumentUrl'] as String? ?? '';
    c.certificateUrls = (data['certificateUrls'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }
}
