import 'dart:io';
import 'package:fitness_app/features/coach_profile/data/repos/coach_profile_repo.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coach_profile_state.dart';

class CoachProfileCubit extends Cubit<CoachProfileState> {
  final CoachProfileRepo repository;

  CoachProfileCubit({required this.repository})
      : super(const CoachProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await repository.getCoachProfile();
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

  Future<void> updateProfile(CoachProfileModel updated) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));
    final result = await repository.updateCoachProfile(updated);
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

  Future<void> updatePricing({
    required double sessionPriceUSD,
    required double monthlyPriceUSD,
  }) async {
    final uid = state.profile?.uid;
    if (uid == null) return;

    emit(state.copyWith(isSaving: true, errorMessage: null));
    final result = await repository.updatePricing(
      uid: uid,
      sessionPriceUSD: sessionPriceUSD,
      monthlyPriceUSD: monthlyPriceUSD,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        errorMessage: failure.errorMessage,
      )),
      (profile) => emit(state.copyWith(
        isSaving: false,
        profile: profile,
        successMessage: 'pricing_updated',
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
          final saveResult = await repository.updateCoachProfile(updated);
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
