import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_profile_cubit/coach_profile_cubit.dart';
import '../view_model/coach_profile_cubit/coach_profile_state.dart';
import '../widgets/coach_account_settings_section.dart';
import '../widgets/coach_profile_bio_section.dart';
import '../widgets/coach_profile_certificates_section.dart';
import '../widgets/coach_profile_header_widget.dart';
import '../widgets/coach_profile_pricing_card_widget.dart';
import '../widgets/coach_profile_sports_locations_widget.dart';

class CoachProfileView extends StatelessWidget {
  const CoachProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoachProfileCubit>()..loadProfile(),
      child: const _CoachProfileContent(),
    );
  }
}

class _CoachProfileContent extends StatelessWidget {
  const _CoachProfileContent();

  void _handleStateMessages(BuildContext context, CoachProfileState state) {
    final s = S.of(context);
    final cubit = context.read<CoachProfileCubit>();
    if (state.successMessage == 'profile_updated') {
      Message.showSuccess(context, s.profileUpdatedSuccess);
      cubit.clearMessages();
    } else if (state.successMessage == 'pricing_updated') {
      Message.showSuccess(context, s.pricingUpdatedSuccess);
      cubit.clearMessages();
    } else if (state.successMessage == 'avatar_updated') {
      Message.showSuccess(context, s.avatarUpdatedSuccess);
      cubit.clearMessages();
    } else if (state.errorMessage != null) {
      Message.showError(context, state.errorMessage!);
      cubit.clearMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).coachProfileTitle),
        centerTitle: true,
      ),
      body: BlocConsumer<CoachProfileCubit, CoachProfileState>(
        listener: _handleStateMessages,
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.profile == null) {
            return _buildError(context);
          }
          final profile = state.profile;
          if (profile == null) return const SizedBox.shrink();

          return RefreshIndicator(
            onRefresh: () => context
                .read<CoachProfileCubit>()
                .loadProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  CoachProfileHeaderWidget(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  CoachProfilePricingCardWidget(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  CoachProfileBioSection(profile: profile),
                  SizedBox(height: AppSpacing.s4),
                  CoachProfileCertificatesSection(
                    certificateUrls: profile.certificateUrls,
                    verificationStatus: profile.verificationStatus,
                  ),
                  if (profile.sports.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.s4),
                    CoachProfileSportsLocationsWidget(profile: profile),
                  ],
                  SizedBox(height: AppSpacing.s4),
                  const CoachAccountSettingsSection(),
                  SizedBox(height: AppSpacing.s5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 48.r, color: AppColors.error),
          SizedBox(height: 12.h),
          Text(s.loadProfileError),
          SizedBox(height: 16.h),
          AppButton(
            label: s.tryAgain,
            size: AppButtonSize.sm,
            onPressed: () => context
                .read<CoachProfileCubit>()
                .loadProfile(),
          ),
        ],
      ),
    );
  }
}

