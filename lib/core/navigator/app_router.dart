import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/forget_password/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/choose_role_view.dart';
import '../../features/auth/sign_in/presentation/views/sign_in_view.dart';
import '../../features/auth/sign_up/presentation/views/sign_up_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
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
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInView(),
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
