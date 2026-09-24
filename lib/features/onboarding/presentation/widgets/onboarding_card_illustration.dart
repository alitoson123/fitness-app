import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../data/models/onboarding_item_model.dart';
import 'illustration_coach_card.dart';
import 'illustration_schedule_card.dart';
import 'illustration_stats_card.dart';

class OnboardingCardIllustration extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingCardIllustration({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 310.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkSurfaceVariant.withValues(alpha: 0.9),
            AppColors.darkSurface.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: AppRadius.xxlAll,
        border: Border.all(
          color: item.accentColor.withValues(alpha: 0.25),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: item.accentColor.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xxlAll,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background ambient glow circle
            Positioned(
              top: -30.h,
              right: -30.w,
              child: Container(
                width: 140.r,
                height: 140.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.accentColor.withValues(alpha: 0.15),
                ),
              ),
            ),
            // Dynamic card based on type
            _buildIllustrationContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustrationContent() {
    switch (item.type) {
      case OnboardingType.coaches:
        return const IllustrationCoachCard();
      case OnboardingType.scheduling:
        return const IllustrationScheduleCard();
      case OnboardingType.analytics:
        return const IllustrationStatsCard();
    }
  }
}
