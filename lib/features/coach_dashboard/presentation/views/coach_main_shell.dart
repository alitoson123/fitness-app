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
import '../../../coach_availability/presentation/views/coach_availability_view.dart';
import '../../../coach_setup/presentation/view_model/coach_status_cubit/coach_status_cubit.dart';
import '../../../coach_setup/presentation/view_model/coach_status_cubit/coach_status_states.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_cubit.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_states.dart';
import '../widgets/coach_bottom_nav_bar.dart';
import 'coach_bookings_page.dart';
import 'coach_dashboard_page.dart';

class CoachMainShell extends StatefulWidget {
  const CoachMainShell({super.key});

  @override
  State<CoachMainShell> createState() => _CoachMainShellState();
}

class _CoachMainShellState extends State<CoachMainShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = getIt<AuthService>().currentUser?.uid ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthSessionCubit>()),
        BlocProvider(
          create: (_) =>
              getIt<CoachVerificationStatusCubit>()
                ..listenToVerificationStatus(),
        ),
        BlocProvider(
          create: (_) => getIt<CoachBookingsCubit>()..listenToBookings(uid),
        ),
      ],
      child: PopScope(
        canPop: _currentIndex == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          setState(() => _currentIndex = 0);
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthSessionCubit, AuthSessionStates>(
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
            ),
            BlocListener<CoachVerificationStatusCubit,
                CoachVerificationStatusState>(
              listener: (context, state) {
                if (state is CoachVerificationStatusRejectedState ||
                    state is CoachVerificationStatusPendingState) {
                  context.go(AppRoutes.coachVerificationPending);
                }
              },
            ),
            BlocListener<CoachBookingsCubit, CoachBookingsState>(
              listener: (context, state) {
                if (state.successMessage == 'accepted') {
                  Message.showSuccess(
                    context,
                    S.of(context).requestAcceptedSuccess,
                  );
                  context.read<CoachBookingsCubit>().clearMessages();
                } else if (state.successMessage == 'rejected') {
                  Message.showSuccess(
                    context,
                    S.of(context).requestRejectedSuccess,
                  );
                  context.read<CoachBookingsCubit>().clearMessages();
                } else if (state.successMessage == 'rescheduled') {
                  Message.showSuccess(
                    context,
                    S.of(context).rescheduleRequestedSuccess,
                  );
                  context.read<CoachBookingsCubit>().clearMessages();
                } else if (state.errorMessage != null) {
                  Message.showError(context, state.errorMessage!);
                  context.read<CoachBookingsCubit>().clearMessages();
                }
              },
            ),
          ],
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                CoachDashboardPage(onNavigateToTab: _onTabSelected),
                const CoachBookingsPage(),
                const CoachAvailabilityView(isRootTab: true),
              ],
            ),
            bottomNavigationBar:
                BlocBuilder<CoachBookingsCubit, CoachBookingsState>(
                  buildWhen: (prev, curr) =>
                      prev.pendingCount != curr.pendingCount,
                  builder: (context, state) {
                    return CoachBottomNavBar(
                      currentIndex: _currentIndex,
                      pendingCount: state.pendingCount,
                      onTap: _onTabSelected,
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
