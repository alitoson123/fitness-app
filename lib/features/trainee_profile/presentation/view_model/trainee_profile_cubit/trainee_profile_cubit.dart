import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repos/trainee_profile_repo.dart';
import '../../../../trainee_setup/data/models/trainee_profile_model.dart';
import 'trainee_profile_state.dart';

class TraineeProfileCubit extends Cubit<TraineeProfileState> {
  final TraineeProfileRepo repository;

  TraineeProfileCubit({required this.repository})
      : super(const TraineeProfileState());

  Future<void> loadProfile({bool forceRefresh = false}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await repository.getTraineeProfile(
      forceRefresh: forceRefresh,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.errorMessage,
      )),
      (profile) => emit(state.copyWith(
        isLoading: false,
        profile: profile,
      )),
    );
  }

  Future<void> updateProfile(TraineeProfileModel updated) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));
    final result = await repository.updateTraineeProfile(updated);
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        errorMessage: failure.errorMessage,
      )),
      (profile) => emit(state.copyWith(
        isSaving: false,
        profile: profile,
        successMessage: 'profile_updated',
      )),
    );
  }

  Future<void> uploadAvatar(File imageFile) async {
    final uid = state.profile?.uid;
    if (uid == null) return;

    emit(state.copyWith(isUploadingAvatar: true, errorMessage: null));
    final result = await repository.uploadAvatar(
      imageFile: imageFile,
      uid: uid,
    );

    await result.fold(
      (failure) async => emit(state.copyWith(
        isUploadingAvatar: false,
        errorMessage: failure.errorMessage,
      )),
      (downloadUrl) async {
        final current = state.profile;
        if (current != null) {
          final updated = current.copyWith(photoUrl: downloadUrl);
          final saveResult = await repository.updateTraineeProfile(updated);
          saveResult.fold(
            (failure) => emit(state.copyWith(
              isUploadingAvatar: false,
              errorMessage: failure.errorMessage,
            )),
            (saved) => emit(state.copyWith(
              isUploadingAvatar: false,
              profile: saved,
              successMessage: 'avatar_updated',
            )),
          );
        } else {
          emit(state.copyWith(isUploadingAvatar: false));
        }
      },
    );
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
