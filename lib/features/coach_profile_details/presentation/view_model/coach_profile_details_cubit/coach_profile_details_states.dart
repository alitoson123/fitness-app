import 'package:fitness_app/core/models/day_availability.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

abstract class CoachProfileDetailsState {
  const CoachProfileDetailsState();
}

class CoachProfileDetailsInitial extends CoachProfileDetailsState {
  const CoachProfileDetailsInitial();
}

class CoachProfileDetailsLoading extends CoachProfileDetailsState {
  const CoachProfileDetailsLoading();
}

class CoachProfileDetailsLoaded extends CoachProfileDetailsState {
  final CoachProfileModel coach;
  final List<String> certificateUrls;
  final List<DayAvailability> schedule;

  const CoachProfileDetailsLoaded({
    required this.coach,
    this.certificateUrls = const [],
    this.schedule = const [],
  });

  bool get hasCertificates => certificateUrls.isNotEmpty;
  bool get hasSchedule => schedule.isNotEmpty;

  CoachProfileDetailsLoaded copyWith({
    CoachProfileModel? coach,
    List<String>? certificateUrls,
    List<DayAvailability>? schedule,
  }) {
    return CoachProfileDetailsLoaded(
      coach: coach ?? this.coach,
      certificateUrls: certificateUrls ?? this.certificateUrls,
      schedule: schedule ?? this.schedule,
    );
  }
}

class CoachProfileDetailsError extends CoachProfileDetailsState {
  final String errorMessage;

  const CoachProfileDetailsError({required this.errorMessage});
}
