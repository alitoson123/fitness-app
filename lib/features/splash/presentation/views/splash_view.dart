import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/navigator/auth_route_resolver.dart';
import '../../../../core/services/notification_service/notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../auth/core/data/data_source/auth_local_data_source.dart';
import '../../../auth/core/domain/repo/auth_session_repo.dart';

sealed class _SplashOutcome {
  const _SplashOutcome();
}

class _SplashRoute extends _SplashOutcome {
  final String route;
  const _SplashRoute(this.route);
}

class _SplashBlocked extends _SplashOutcome {
  final _SplashProblem problem;
  const _SplashBlocked(this.problem);
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

enum _SplashProblem { connection, suspended, adminAccount }

class _SplashViewState extends State<SplashView> {
  _SplashProblem? _problem;
  bool _isWorking = true;

  @override
  void initState() {
    super.initState();
    _navigateToNext(withMinimumDelay: true);
  }

  Future<void> _navigateToNext({bool withMinimumDelay = false}) async {
    if (_problem != null) {
      setState(() {
        _problem = null;
        _isWorking = true;
      });
    }
    // Keep the brand visible briefly, but do the real work in parallel.
    final minimumDelay = withMinimumDelay
        ? Future<void>.delayed(const Duration(milliseconds: 1200))
        : Future<void>.value();
    final outcome = await _resolve();
    await minimumDelay;
    if (!mounted) return;

    final notificationService = getIt<NotificationService>();
    switch (outcome) {
      case _SplashRoute(:final route):
        context.go(route);
        if (route != AppRoutes.signIn) {
          await notificationService.consumePendingDeepLink();
        } else {
          notificationService.clearPendingDeepLink();
        }
      case _SplashBlocked(:final problem):
        if (problem != _SplashProblem.connection) {
          notificationService.clearPendingDeepLink();
        }
        setState(() {
          _problem = problem;
          _isWorking = false;
        });
    }
  }

  Future<_SplashOutcome> _resolve() async {
    final firebaseUser = await getIt<AuthService>().restoreCurrentUser();
    final cachedUser = await getIt<AuthLocalDataSource>().getUser();

    // Only a real Firebase session that matches the cached account counts as
    // signed in. Anything else (signed out elsewhere, login deleted/disabled,
    // stale cache from another account) starts clean.
    if (firebaseUser == null ||
        cachedUser == null ||
        cachedUser.uid != firebaseUser.uid) {
      if (firebaseUser != null || cachedUser != null) {
        await getIt<AuthSessionRepo>().signOut();
      }
      return const _SplashRoute(AppRoutes.signIn);
    }

    try {
      final route = await getIt<AuthRouteResolver>().resolveTargetRoute(
        uid: cachedUser.uid,
        role: cachedUser.role,
      );
      getIt<NotificationService>().syncFcmToken(
        cachedUser.uid,
        role: cachedUser.role,
      );
      return _SplashRoute(route);
    } on AuthAccessDeniedException catch (e) {
      await getIt<AuthSessionRepo>().signOut();
      return _SplashBlocked(
        e.reason == AuthAccessDeniedReason.suspended
            ? _SplashProblem.suspended
            : _SplashProblem.adminAccount,
      );
    } catch (_) {
      return const _SplashBlocked(_SplashProblem.connection);
    }
  }

  Future<void> _signOutAndContinue() async {
    setState(() => _isWorking = true);
    await getIt<AuthSessionRepo>().signOut();
    if (!mounted) return;
    getIt<NotificationService>().clearPendingDeepLink();
    context.go(AppRoutes.signIn);
  }

  Widget _buildProblemPanel(BuildContext context, _SplashProblem problem) {
    final s = S.of(context);
    final message = switch (problem) {
      _SplashProblem.connection => s.connectionErrorMessage,
      _SplashProblem.suspended => s.accountSuspendedMessage,
      _SplashProblem.adminAccount => s.adminUseDashboardMessage,
    };
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      minimumSize: Size(double.infinity, 48.h),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.4,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          SizedBox(height: 20.h),
          if (problem == _SplashProblem.connection) ...[
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => _navigateToNext(),
              child: Text(s.retry),
            ),
            TextButton(
              onPressed: _signOutAndContinue,
              child: Text(
                s.signOut,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ] else
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => context.go(AppRoutes.signIn),
              child: Text(s.ok),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.splashGradient,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96.r,
              height: 96.r,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: AppRadius.xxlAll,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: 48.r,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              S.of(context).appName,
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              S.of(context).splashSubtitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.60),
              ),
            ),
            SizedBox(height: 40.h),
            if (_problem != null && !_isWorking)
              _buildProblemPanel(context, _problem!)
            else if (_isWorking && _problem == null)
              SizedBox(
                width: 22.r,
                height: 22.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
