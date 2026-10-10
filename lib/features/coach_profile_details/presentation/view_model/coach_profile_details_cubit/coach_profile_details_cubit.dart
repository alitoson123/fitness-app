import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:fitness_app/features/coach_profile_details/data/repos/coach_profile_details_repo.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_profile_details_states.dart';

class CoachProfileDetailsCubit extends Cubit<CoachProfileDetailsState> {
  final CoachProfileDetailsRepo repository;

  CoachProfileDetailsCubit({required this.repository})
      : super(const CoachProfileDetailsInitial());

  Future<void> loadCoachDetails({
    required String coachUid,
    CoachProfileModel? initialCoach,
  }) async {
    LoggerService.info(
      'Loading coach details for $coachUid in Cubit',
      tag: 'CoachProfileDetailsCubit',
    );

    if (initialCoach != null) {
      emit(
        CoachProfileDetailsLoaded(
          coach: initialCoach,
          certificateUrls: initialCoach.certificateUrls,
          schedule: initialCoach.weeklyAvailability,
        ),
      );
    } else {
      emit(const CoachProfileDetailsLoading());
    }

    final result = await repository.getCoachDetails(
      coachUid: coachUid,
      initialCoach: initialCoach,
    );

    result.fold(
      (failure) {
        if (state is! CoachProfileDetailsLoaded) {
          emit(CoachProfileDetailsError(errorMessage: failure.errorMessage));
        } else {
          LoggerService.warning(
            'Failed background refresh for coach: ${failure.errorMessage}',
            tag: 'CoachProfileDetailsCubit',
          );
        }
      },
      (completeCoach) {
        emit(
          CoachProfileDetailsLoaded(
            coach: completeCoach,
            certificateUrls: completeCoach.certificateUrls,
            schedule: completeCoach.weeklyAvailability,
          ),
        );
      },
    );
  }

  Future<void> refresh(String coachUid) async {
    final currentCoach =
        state is CoachProfileDetailsLoaded
            ? (state as CoachProfileDetailsLoaded).coach
            : null;
    await loadCoachDetails(coachUid: coachUid, initialCoach: currentCoach);
  }
}
