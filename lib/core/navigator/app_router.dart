import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/forget_password/presentation/views/forget_password_view.dart';
import '../../features/auth/choose_role/presentation/views/choose_role_view.dart';
import '../../features/auth/sign_in/presentation/views/sign_in_view.dart';
import '../../features/auth/sign_up/presentation/views/sign_up_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/trainee_setup/presentation/views/trainee_setup_view.dart';
import '../../features/trainee_setup/presentation/views/trainee_success_view.dart';
import '../../generated/l10n.dart';
import 'app_routes.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => SignInView(
          initialParams: state.extra as (String email, String password)?,
        ),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: AppRoutes.chooseRole,
        builder: (context, state) => const ChooseRoleView(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.traineeSetup,
        builder: (context, state) => const TraineeSetupView(),
      ),
      GoRoute(
        path: AppRoutes.traineeSuccess,
        builder: (context, state) => const TraineeSuccessView(),
      ),
      GoRoute(
        path: AppRoutes.traineeHome,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(S.of(context).traineeDiscovery)),
          body: Center(
            child: Text(
              S.of(context).traineeMarketplacePlaceholder,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.coachDashboard,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(S.of(context).coachDashboard)),
          body: Center(
            child: Text(
              S.of(context).coachDashboardPlaceholder,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    ],
  );
}
