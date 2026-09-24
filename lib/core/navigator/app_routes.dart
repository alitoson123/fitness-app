/// Centralized Route Name Constants
abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String chooseRole = '/choose-role';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  
  // Trainee routes
  static const String traineeSetup = '/trainee/setup';
  static const String traineeSuccess = '/trainee/success';
  static const String traineeHome = '/trainee/home';
  static const String traineeProfile = '/trainee/profile';
  static const String coachDetails = '/trainee/coach-details';
  static const String bookingRequest = '/trainee/booking-request';
  static const String traineeBookings = '/trainee/bookings';

  // Coach routes
  static const String coachRegistration = '/coach/register';
  static const String coachVerificationPending = '/coach/verification-pending';
  static const String coachDashboard = '/coach/dashboard';
  static const String coachAvailability = '/coach/availability';
}
