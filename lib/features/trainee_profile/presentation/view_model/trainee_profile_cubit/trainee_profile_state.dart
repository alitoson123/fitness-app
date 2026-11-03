import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';

class TraineeProfileState {
  final TraineeProfileModel? profile;
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingAvatar;
  final String? errorMessage;
  final String? successMessage;

  const TraineeProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.errorMessage,
    this.successMessage,
  });

  TraineeProfileState copyWith({
    TraineeProfileModel? profile,
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingAvatar,
    String? errorMessage,
    String? successMessage,
  }) {
    return TraineeProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

