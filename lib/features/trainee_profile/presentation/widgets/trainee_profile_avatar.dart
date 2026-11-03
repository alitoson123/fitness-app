import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_cubit.dart';
import '../view_model/trainee_profile_cubit/trainee_profile_state.dart';

class TraineeProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final VoidCallback onChangePhoto;

  const TraineeProfileAvatar({
    super.key,
    required this.photoUrl,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = photoUrl ?? '';

    return BlocBuilder<TraineeProfileCubit, TraineeProfileState>(
      buildWhen: (prev, curr) =>
          prev.isUploadingAvatar != curr.isUploadingAvatar,
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2.5),
              ),
              child: ClipOval(
                child: effectiveUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: effectiveUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: AppColors.textTertiary,
                        ),
                      )
                    : const Icon(
                        Icons.person_rounded,
                        size: 50,
                        color: AppColors.textTertiary,
                      ),
              ),
            ),
            if (state.isUploadingAvatar)
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: onChangePhoto,
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 16.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

