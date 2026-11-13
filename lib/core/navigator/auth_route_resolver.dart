import '../../core/constant/app_constants.dart';
import '../../core/navigator/app_routes.dart';
import '../../core/services/database_service/firestore_service.dart';

/// Why a signed-in account is not allowed into the mobile app.
enum AuthAccessDeniedReason {
  /// An admin suspended this account.
  suspended,

  /// Admin accounts only use the web dashboard.
  adminAccount,
}

/// Thrown by [AuthRouteResolver] when the account must not enter the app.
/// Callers sign the user out and explain why.
class AuthAccessDeniedException implements Exception {
  final AuthAccessDeniedReason reason;
  const AuthAccessDeniedException(this.reason);

  @override
  String toString() => 'AuthAccessDeniedException($reason)';
}

/// Resolves the target route for an authenticated user based on role,
/// setup completion, and coach application status.
///
/// Errors while reading Firestore (e.g. no connection) are NOT swallowed:
/// guessing a route on failure used to send finished users back into setup.
/// Callers show a retry option instead.
class AuthRouteResolver {
  final FirestoreService _firestoreService;

  AuthRouteResolver({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  /// Determines the appropriate destination route.
  ///
  /// [role] is the locally known role; the role stored on the server wins
  /// when present, so changes made from the dashboard take effect.
  /// Throws [AuthAccessDeniedException] for suspended or admin accounts.
  Future<String> resolveTargetRoute({
    required String uid,
    required String role,
  }) async {
    final userDoc = await _firestoreService.getDoc(
      collection: AppConstants.usersCollection,
      docId: uid,
    );
    final userData = userDoc.data();
    final userStatus = userData?['status'] as String? ?? 'active';
    if (userStatus == 'suspended') {
      throw const AuthAccessDeniedException(AuthAccessDeniedReason.suspended);
    }

    final serverRole = userData?['role'] as String?;
    final effectiveRole =
        (serverRole != null && serverRole.isNotEmpty) ? serverRole : role;

    switch (effectiveRole) {
      case 'admin':
        throw const AuthAccessDeniedException(
          AuthAccessDeniedReason.adminAccount,
        );
      case 'coach':
        return _resolveCoachRoute(uid);
      case 'trainee':
        return _resolveTraineeRoute(uid);
      default:
        return AppRoutes.chooseRole;
    }
  }

  Future<String> _resolveCoachRoute(String uid) async {
    final verificationDoc = await _firestoreService.getDoc(
      collection: AppConstants.verificationsCollection,
      docId: uid,
    );

    if (!verificationDoc.exists || verificationDoc.data() == null) {
      return AppRoutes.coachRegistration;
    }

    final status = verificationDoc.data()!['status'] as String? ?? 'pending';
    if (status == 'approved') {
      return AppRoutes.coachDashboard;
    }
    return AppRoutes.coachVerificationPending;
  }

  Future<String> _resolveTraineeRoute(String uid) async {
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
}
