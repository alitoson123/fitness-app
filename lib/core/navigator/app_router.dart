import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/locator_service/service_locator.dart';
import '../../features/auth/choose_role/presentation/views/choose_role_view.dart';
import '../../features/auth/phone_sign_in/presentation/view_model/phone_auth_cubit/phone_auth_cubit.dart';
import '../../features/auth/phone_sign_in/presentation/views/otp_verification_view.dart';
import '../../features/auth/phone_sign_in/presentation/views/phone_sign_in_view.dart';
import '../../features/coach_dashboard/presentation/views/coach_main_shell.dart';
import '../../features/coach_setup/data/models/coach_application_model.dart';
import '../../features/coach_setup/data/models/coach_profile_model.dart';
import '../../features/coach_setup/presentation/views/coach_registration_view.dart';
import '../../features/coach_setup/presentation/views/coach_verification_pending_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/trainee_discovery/presentation/views/trainee_home_view.dart';
import '../../features/coach_profile_details/presentation/views/coach_details_view.dart';
import '../../features/coach_availability/presentation/views/coach_availability_view.dart';
import '../../features/trainee_setup/presentation/views/trainee_setup_view.dart';
import '../../features/trainee_setup/presentation/views/trainee_success_view.dart';
import '../../features/booking_request/presentation/views/booking_request_view.dart';
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
        builder: (context, state) => BlocProvider<PhoneAuthCubit>(
          create: (_) => getIt<PhoneAuthCubit>(),
          child: const PhoneSignInView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final cubit = state.extra as PhoneAuthCubit? ?? getIt<PhoneAuthCubit>();
          return OtpVerificationView(cubit: cubit);
        },
      ),
      GoRoute(
        path: AppRoutes.chooseRole,
        builder: (context, state) => const ChooseRoleView(),
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
        path: AppRoutes.traineeProfile,
        builder: (context, state) => const TraineeHomeView(initialIndex: 2),
      ),
      GoRoute(
        path: AppRoutes.coachDashboard,
        builder: (context, state) => const CoachMainShell(),
      ),
      GoRoute(
        path: AppRoutes.coachAvailability,
        builder: (context, state) {
          final coachUid = state.extra as String?;
          return CoachAvailabilityView(coachUid: coachUid);
        },
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
      GoRoute(
        path: AppRoutes.bookingRequest,
        builder: (context, state) {
          final coach = state.extra as CoachProfileModel?;
          if (coach != null) {
            return BookingRequestView(coach: coach);
          }
          return const TraineeHomeView();
        },
      ),
      GoRoute(
        path: AppRoutes.traineeBookings,
        builder: (context, state) => const TraineeHomeView(initialIndex: 1),
      ),
    ],
  );
}
