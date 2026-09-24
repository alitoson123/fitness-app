import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_page_indicator.dart';
import '../../../../generated/l10n.dart';

class OnboardingBottomControls extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onGetStarted;

  const OnboardingBottomControls({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onGetStarted,
  });

  bool get isLastPage => currentIndex == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s5,
        vertical: AppSpacing.s4,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: isLastPage
            ? AppButton(
                key: const ValueKey('get_started_btn'),
                label: S.of(context).getStartedNow,
                size: AppButtonSize.lg,
                fullWidth: true,
                iconRight: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: onGetStarted,
              )
            : Row(
                key: const ValueKey('nav_row'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppPageIndicator(
                    total: totalPages,
                    current: currentIndex,
                  ),
                  _buildNextCircleButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildNextCircleButton() {
    return Container(
      width: 54.r,
      height: 54.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: AppColors.flameGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: AppShadows.flame,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onNext,
          borderRadius: AppRadius.fullAll,
          child: const Center(
            child: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
