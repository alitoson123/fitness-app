import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/navigator/app_routes.dart';
import 'package:fitness_app/core/navigator/auth_route_resolver.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/auth/core/data/models/user_model.dart';
import 'package:fitness_app/features/auth/sign_in/data/repo_impl/sign_in_repo_impl.dart';
import 'package:fitness_app/features/auth/sign_in/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:fitness_app/features/auth/sign_in/presentation/view_model/sign_in_cubit/sign_in_states.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSignInRepoImpl implements SignInRepoImpl {
  UserModel? userToReturn;

  @override
  Future<Either<Failure, UserModel>> signInMethod({
    required String email,
    required String password,
  }) async {
    return Right(userToReturn!);
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogleMethod() async {
    return Right(userToReturn!);
  }

  @override
  Future<Either<Failure, UserModel>> signInWithAppleMethod() async {
    return Right(userToReturn!);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthService implements AuthService {
  bool isEmailVerified = true;

  @override
  Future<bool> reloadAndCheckEmailVerified() async {
    return isEmailVerified;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthRouteResolver implements AuthRouteResolver {
  String resolvedRoute = AppRoutes.coachRegistration;

  @override
  Future<String> resolveTargetRoute({
    required String uid,
    required String role,
  }) async {
    return resolvedRoute;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SignInCubit Tests', () {
    late FakeSignInRepoImpl fakeRepo;
    late FakeAuthService fakeAuth;
    late FakeAuthRouteResolver fakeResolver;
    late SignInCubit cubit;

    setUp(() {
      fakeRepo = FakeSignInRepoImpl();
      fakeAuth = FakeAuthService();
      fakeResolver = FakeAuthRouteResolver();
      cubit = SignInCubit(
        signInRepoImpl: fakeRepo,
        authService: fakeAuth,
        authRouteResolver: fakeResolver,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('signInMethod emits SignInSuccessState with targetRoute', () async {
      fakeRepo.userToReturn = UserModel(
        uid: 'coach1',
        name: 'Coach Test',
        email: 'coach@test.com',
        role: 'coach',
      );
      fakeResolver.resolvedRoute = AppRoutes.coachVerificationPending;

      await cubit.signInMethod(email: 'coach@test.com', password: 'password123');

      expect(cubit.state, isA<SignInSuccessState>());
      final success = cubit.state as SignInSuccessState;
      expect(success.user.uid, 'coach1');
      expect(success.targetRoute, AppRoutes.coachVerificationPending);
    });

    test('signInMethod routes unfinished coach to coachRegistration', () async {
      fakeRepo.userToReturn = UserModel(
        uid: 'coach2',
        name: 'Coach Draft',
        email: 'coach2@test.com',
        role: 'coach',
      );
      fakeResolver.resolvedRoute = AppRoutes.coachRegistration;

      await cubit.signInMethod(email: 'coach2@test.com', password: 'password123');

      expect(cubit.state, isA<SignInSuccessState>());
      final success = cubit.state as SignInSuccessState;
      expect(success.targetRoute, AppRoutes.coachRegistration);
    });

    test('signInMethod routes approved coach to coachDashboard', () async {
      fakeRepo.userToReturn = UserModel(
        uid: 'coach3',
        name: 'Coach Approved',
        email: 'coach3@test.com',
        role: 'coach',
      );
      fakeResolver.resolvedRoute = AppRoutes.coachDashboard;

      await cubit.signInMethod(email: 'coach3@test.com', password: 'password123');

      expect(cubit.state, isA<SignInSuccessState>());
      final success = cubit.state as SignInSuccessState;
      expect(success.targetRoute, AppRoutes.coachDashboard);
    });
  });
}
