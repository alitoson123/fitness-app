import 'package:fitness_app/features/coach_setup/data/models/coach_application_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

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
      'specialties': cubit.specialties,
      'yearsOfExperience': cubit.yearsOfExperience,
      'hourlyRate': cubit.sessionPrice,
      'currency': cubit.currency,
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
      yearsOfExperience: cubit.yearsOfExperience,
      sessionPrice: cubit.sessionPrice,
      currency: cubit.currency,
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
}
