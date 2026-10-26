import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_states.dart';
import '../../../trainee_bookings/presentation/view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import '../../../trainee_bookings/presentation/views/trainee_bookings_page.dart';
import '../../../trainee_profile/presentation/view_model/trainee_profile_cubit/trainee_profile_cubit.dart';
import '../../../trainee_profile/presentation/views/trainee_profile_page.dart';
import '../view_model/coach_discovery_cubit/coach_discovery_cubit.dart';
import '../widgets/trainee_bottom_nav_bar.dart';
import 'trainee_discovery_page.dart';

class TraineeHomeView extends StatefulWidget {
  final int initialIndex;

  const TraineeHomeView({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<TraineeHomeView> createState() => _TraineeHomeViewState();
}

class _TraineeHomeViewState extends State<TraineeHomeView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = getIt<AuthService>().currentUser?.uid ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<CoachDiscoveryCubit>()..loadCoaches(),
        ),
        BlocProvider(create: (_) => getIt<AuthSessionCubit>()),
        BlocProvider(
          create: (_) => getIt<TraineeProfileCubit>()..loadProfile(),
        ),
        BlocProvider(
          create: (_) => getIt<TraineeBookingsCubit>()..listenToBookings(currentUid),
        ),
      ],
      child: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          setState(() => _currentIndex = 0);
        },
        child: BlocListener<AuthSessionCubit, AuthSessionStates>(
          listener: (context, state) {
            if (state is AuthSessionSignOutSuccessState) {
              context.go(AppRoutes.signIn);
            } else if (state is AuthSessionDeleteSuccessState) {
              Message.showSuccess(
                context,
                S.of(context).accountDeletedSuccess,
              );
              context.go(AppRoutes.signIn);
            } else if (state is AuthSessionErrorState) {
              Message.showError(context, state.errorMessage);
            }
          },
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: const [
                TraineeDiscoveryPage(),
                TraineeBookingsPage(),
                TraineeProfilePage(),
              ],
            ),
            bottomNavigationBar: TraineeBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTabSelected,
            ),
          ),
        ),
      ),
    );
  }
}
