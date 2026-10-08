import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../helpers/coach_setup_localization_helper.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'coach_review_summary_card.dart';

class StepReviewSubmitWidget extends StatelessWidget {
  final CoachSetupCubit cubit;

  const StepReviewSubmitWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final locationText = cubit.city.isNotEmpty && cubit.country.isNotEmpty
        ? '${cubit.city}, ${cubit.country}'
        : (cubit.country.isNotEmpty
            ? cubit.country
            : (cubit.city.isNotEmpty ? cubit.city : '-'));

    final languagesText = cubit.selectedLanguages
        .map((l) =>
            CoachSetupLocalizationHelper.getLocalizedLanguage(context, l))
        .join(', ');

    final sportsText = cubit.selectedSports
        .map((s) => CoachSetupLocalizationHelper.getLocalizedSport(context, s))
        .join(', ');

    final priceText =
        '${cubit.sessionPrice.toStringAsFixed(0)} ${cubit.currency} ${S.of(context).perSessionUnit}';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).reviewTitle,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).reviewSubtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          CoachReviewSummaryCard(
            title: S.of(context).stepPersonalInfo,
            stepIndex: 0,
            onEditTapped: cubit.goToStep,
            items: [
              (S.of(context).fullName, cubit.name),
              (S.of(context).reviewLocation, locationText),
              (
                S.of(context).reviewAge,
                cubit.age > 0
                    ? '${cubit.age}'
                    : S.of(context).reviewNoneSpecified,
              ),
              (
                S.of(context).reviewGender,
                cubit.gender == 'female'
                    ? S.of(context).female
                    : S.of(context).male,
              ),
              (S.of(context).languages, languagesText),
              (S.of(context).bio, cubit.bio),
            ],
          ),
          SizedBox(height: 12.h),
          CoachReviewSummaryCard(
            title: S.of(context).stepProfessionalInfo,
            stepIndex: 1,
            onEditTapped: cubit.goToStep,
            items: [
              (S.of(context).reviewSports, sportsText),
              (
                S.of(context).specialties,
                cubit.specialties.isNotEmpty
                    ? cubit.specialties.join(', ')
                    : S.of(context).reviewNoneSpecified,
              ),
              (
                S.of(context).yearsOfExperience,
                S.of(context).reviewYearsCount(cubit.yearsOfExperience),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CoachReviewSummaryCard(
            title: S.of(context).stepPricing,
            stepIndex: 2,
            onEditTapped: cubit.goToStep,
            items: [
              (S.of(context).currency, cubit.currency),
              (S.of(context).pricePerSession, priceText),
            ],
          ),
          SizedBox(height: 12.h),
          CoachReviewSummaryCard(
            title: S.of(context).stepAvailability,
            stepIndex: 3,
            onEditTapped: cubit.goToStep,
            items: [
              (S.of(context).reviewAvailability, cubit.availabilitySummary),
            ],
          ),
          SizedBox(height: 12.h),
          CoachReviewSummaryCard(
            title: S.of(context).stepVerificationDocs,
            stepIndex: 4,
            onEditTapped: cubit.goToStep,
            items: [
              (
                S.of(context).reviewGovernmentId,
                cubit.identityDocumentUrl.isNotEmpty
                    ? S.of(context).reviewAttached
                    : S.of(context).reviewMissing,
              ),
              (
                S.of(context).reviewCertificates,
                S.of(context).reviewFilesAttached(
                  cubit.certificateUrls.where((u) => u.isNotEmpty).length,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
