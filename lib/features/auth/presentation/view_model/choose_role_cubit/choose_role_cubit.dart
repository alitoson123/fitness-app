import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../core/services/database_service/firestore_service.dart';
import '../../../core/data/data_source/auth_local_data_source.dart';
import 'choose_role_states.dart';

class ChooseRoleCubit extends Cubit<ChooseRoleStates> {
  final FirestoreService firestoreService;
  final AuthLocalDataSource authLocalDataSource;
  final AuthService authService;

  ChooseRoleCubit({
    required this.firestoreService,
    required this.authLocalDataSource,
    required this.authService,
  }) : super(ChooseRoleInitialState());

  Future<void> saveUserRole({required String role}) async {
    emit(ChooseRoleLoadingState());
    try {
      var cachedUser = await authLocalDataSource.getUser();
      final firebaseUser = authService.currentUser;
      final uid = cachedUser?.uid ?? firebaseUser?.uid;

      if (uid == null) {
        emit(ChooseRoleErrorState(errMessage: 'User session not found. Please log in again.'));
        return;
      }

      await firestoreService.updateData(
        collection: AppConstants.usersCollection,
        docId: uid,
        data: {'role': role},
      );

      if (role == 'coach') {
        await firestoreService.setData(
          collection: AppConstants.coachProfilesCollection,
          docId: uid,
          data: {
            'userId': uid,
            'name': cachedUser?.name ?? firebaseUser?.displayName ?? 'Coach',
            'email': cachedUser?.email ?? firebaseUser?.email ?? '',
            'verificationStatus': 'pending',
            'isAvailable': false,
          },
          merge: true,
        );
      }

      if (cachedUser != null) {
        await authLocalDataSource.saveUser(user: cachedUser.copyWith(role: role));
      }

      emit(ChooseRoleSuccessState(role: role));
    } catch (e) {
      emit(ChooseRoleErrorState(errMessage: e.toString()));
    }
  }
}
