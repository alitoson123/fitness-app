import '../../core/constant/app_constants.dart';
import '../../core/navigator/app_routes.dart';
import '../../core/services/database_service/firestore_service.dart';

/// Resolves the target route for an authenticated user based on role,
/// setup completion, and coach application status.
class AuthRouteResolver {
  final FirestoreService _firestoreService;

  AuthRouteResolver({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  /// Determines the appropriate destination route.
  Future<String> resolveTargetRoute({
    required String uid,
    required String role,
  }) async {
    if (role.isEmpty ||
        (role != 'coach' && role != 'trainee' && role != 'admin')) {
      return AppRoutes.chooseRole;
    }

    try {
      final userDoc = await _firestoreService.getDoc(
        collection: AppConstants.usersCollection,
        docId: uid,
      );
      final userStatus = userDoc.data()?['status'] as String? ?? 'active';
      if (userStatus == 'suspended') {
        return AppRoutes.signIn;
      }

      if (role == 'coach') {
        final verificationDoc = await _firestoreService.getDoc(
          collection: AppConstants.verificationsCollection,
          docId: uid,
        );

        if (!verificationDoc.exists || verificationDoc.data() == null) {
          return AppRoutes.coachRegistration;
        }

        final status =
            verificationDoc.data()!['status'] as String? ?? 'pending';
        if (status == 'approved') {
          return AppRoutes.coachDashboard;
        }
        return AppRoutes.coachVerificationPending;
      }

      if (role == 'trainee') {
        final profileDoc = await _firestoreService.getDoc(
          collection: AppConstants.traineeProfilesCollection,
          docId: uid,
        );

        if (profileDoc.exists && profileDoc.data() != null) {
          final isCompleted =
              (profileDoc.data()!['isProfileCompleted'] as bool?) ?? true;
          if (isCompleted) {
            return AppRoutes.traineeHome;
          }
        }

        return AppRoutes.traineeSetup;
      }
    } catch (_) {
      if (role == 'coach') {
        return AppRoutes.coachVerificationPending;
      } else if (role == 'trainee') {
        return AppRoutes.traineeSetup;
      }
    }

    return AppRoutes.chooseRole;
  }
}
