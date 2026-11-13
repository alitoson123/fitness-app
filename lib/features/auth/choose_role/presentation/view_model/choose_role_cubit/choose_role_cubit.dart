import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constant/app_constants.dart';
import '../../../../../../core/errors/auth_error_messages.dart';
import '../../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../../core/services/database_service/firestore_service.dart';
import '../../../../../../core/services/notification_service/notification_service.dart';
import '../../../../core/data/data_source/auth_local_data_source.dart';
import 'choose_role_states.dart';

class ChooseRoleCubit extends Cubit<ChooseRoleStates> {
  final FirestoreService firestoreService;
  final AuthLocalDataSource authLocalDataSource;
  final AuthService authService;
  final NotificationService? notificationService;

  ChooseRoleCubit({
    required this.firestoreService,
    required this.authLocalDataSource,
    required this.authService,
    this.notificationService,
  }) : super(ChooseRoleInitialState());

  Future<void> saveUserRole({required String role}) async {
    emit(ChooseRoleLoadingState());
    try {
      var cachedUser = await authLocalDataSource.getUser();
      final firebaseUser = authService.currentUser;
      // The signed-in Firebase account is the source of truth.
      final uid = firebaseUser?.uid ?? cachedUser?.uid;

      if (uid == null) {
        emit(ChooseRoleErrorState(errMessage: AuthErrorMessages.unexpected));
        return;
      }

      await firestoreService.updateData(
        collection: AppConstants.usersCollection,
        docId: uid,
        data: {
          'role': role,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );


      if (cachedUser != null) {
        await authLocalDataSource.saveUser(user: cachedUser.copyWith(role: role));
      }

      await notificationService?.syncUserPreferences(uid: uid, role: role);
      emit(ChooseRoleSuccessState(role: role));
    } on FirebaseException catch (e) {
      emit(ChooseRoleErrorState(
        errMessage: e.code == 'unavailable' || e.code == 'network-request-failed'
            ? AuthErrorMessages.connection
            : AuthErrorMessages.unexpected,
      ));
    } catch (_) {
      emit(ChooseRoleErrorState(errMessage: AuthErrorMessages.unexpected));
    }
  }
}
