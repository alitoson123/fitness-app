import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/core/data/data_source/auth_local_data_source.dart';
import '../../../onboarding/data/data_source/onboarding_local_data_source.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
 /*   if (!mounted) return;

    final onboardingDataSource = getIt<OnboardingLocalDataSource>();
    final hasSeenOnboarding = await onboardingDataSource.isOnboardingCompleted();

    if (!hasSeenOnboarding) {
      if (mounted) context.go(AppRoutes.onboarding);
      return;
    }

    final authLocalDataSource = getIt<AuthLocalDataSource>();
    final currentUser = await authLocalDataSource.getUser();

    if (currentUser != null && mounted) {
      if (currentUser.isCoach) {
        context.go(AppRoutes.coachDashboard);
      } else if (currentUser.isTrainee) {
        context.go(AppRoutes.traineeHome);
      } else {
        context.go(AppRoutes.chooseRole);
      }
      return;
    }
*/
    if (mounted) {
      context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.splashGradient,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96.r,
              height: 96.r,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: AppRadius.xxlAll,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: 48.r,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              S.of(context).appName,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              S.of(context).splashSubtitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
