import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/helpers/message.dart';
import '../../../../../core/locator_service/service_locator.dart';
import '../../../../../core/navigator/app_routes.dart';
import '../../../../../generated/l10n.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_states.dart';
import '../../../coach_setup/presentation/view_model/coach_status_cubit/coach_status_cubit.dart';
import '../../../coach_setup/presentation/view_model/coach_status_cubit/coach_status_states.dart';
import '../widgets/coach_dashboard_body.dart';

class CoachDashboardView extends StatelessWidget {
  const CoachDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthSessionCubit>()),
        BlocProvider(
          create: (_) =>
              getIt<CoachVerificationStatusCubit>()..listenToVerificationStatus(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).coachDashboard),
          centerTitle: true,
        ),
        body: MultiBlocListener(
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
          ],
          child: const CoachDashboardBody(),
        ),
      ),
    );
  }
}
