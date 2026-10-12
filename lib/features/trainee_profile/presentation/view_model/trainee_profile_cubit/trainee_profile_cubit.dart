import 'package:fitness_app/features/trainee_setup/data/repos/trainee_setup_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trainee_profile_states.dart';

class TraineeProfileCubit extends Cubit<TraineeProfileState> {
  final TraineeSetupRepo repository;

  TraineeProfileCubit({required this.repository})
      : super(const TraineeProfileInitialState());

  Future<void> loadProfile({bool forceRefresh = false}) async {
    emit(const TraineeProfileLoadingState());
    try {
      final profile = await repository.getTraineeProfile(
        forceRefresh: forceRefresh,
      );
      if (profile != null) {
        emit(TraineeProfileSuccessState(profile));
      } else {
        emit(const TraineeProfileErrorState('Profile not found'));
      }
    } catch (e) {
      emit(TraineeProfileErrorState(e.toString()));
    }
  }
}
