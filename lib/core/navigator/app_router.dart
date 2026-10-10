import 'package:go_router/go_router.dart';
import '../../features/auth/forget_password/presentation/views/forget_password_view.dart';
import '../../features/auth/choose_role/presentation/views/choose_role_view.dart';
import '../../features/auth/sign_in/presentation/views/sign_in_view.dart';
import '../../features/auth/sign_up/presentation/views/sign_up_view.dart';
import '../../features/coach_dashboard/presentation/views/coach_dashboard_view.dart';
import '../../features/coach_setup/data/models/coach_application_model.dart';
import '../../features/coach_setup/data/models/coach_profile_model.dart';
import '../../features/coach_setup/presentation/views/coach_registration_view.dart';
import '../../features/coach_setup/presentation/views/coach_verification_pending_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/trainee_discovery/presentation/views/trainee_home_view.dart';
import '../../features/coach_profile_details/presentation/views/coach_details_view.dart';
import '../../features/trainee_setup/presentation/views/trainee_setup_view.dart';
import '../../features/trainee_setup/presentation/views/trainee_success_view.dart';
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
        path: AppRoutes.coachRegistration,
        builder: (context, state) => CoachRegistrationView(
          initialData: state.extra as (CoachProfileModel?, CoachApplicationModel?)?,
        ),
      ),
      GoRoute(
        path: AppRoutes.coachVerificationPending,
        builder: (context, state) => const CoachVerificationPendingView(),
      ),
      GoRoute(
        path: AppRoutes.traineeHome,
        builder: (context, state) => const TraineeHomeView(),
      ),
      GoRoute(
        path: AppRoutes.coachDashboard,
        builder: (context, state) => const CoachDashboardView(),
      ),
      GoRoute(
        path: AppRoutes.coachDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is CoachProfileModel) {
            return CoachDetailsView(initialCoach: extra, coachUid: extra.uid);
          } else if (extra is String) {
            return CoachDetailsView(coachUid: extra);
          }
          return const CoachDetailsView();
        },
      ),
    ],
  );
}
