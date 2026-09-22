import 'package:fitness_app/core/services/auth_service/auth_service.dart';

class ForgetPasswordRemoteDataSource {
  final AuthService authService;

  ForgetPasswordRemoteDataSource({required this.authService});

  Future<void> forgetPasswordMethod({required String email}) async {
    await authService.sendPasswordResetEmail(email: email);
  }
}
