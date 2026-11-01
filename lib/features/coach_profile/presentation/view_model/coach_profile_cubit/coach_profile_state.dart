import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

class CoachProfileState {
  final CoachProfileModel? profile;
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingAvatar;
  final String? errorMessage;
  final String? successMessage;

  const CoachProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.errorMessage,
    this.successMessage,
  });

  CoachProfileState copyWith({
    CoachProfileModel? profile,
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingAvatar,
    String? errorMessage,
    String? successMessage,
  }) {
    return CoachProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
