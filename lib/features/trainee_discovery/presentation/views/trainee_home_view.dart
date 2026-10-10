import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_states.dart';
import '../view_model/coach_discovery_cubit/coach_discovery_cubit.dart';
import '../widgets/trainee_discovery_body.dart';

class TraineeHomeView extends StatelessWidget {
  const TraineeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<CoachDiscoveryCubit>()..loadCoaches(),
        ),
        BlocProvider(create: (_) => getIt<AuthSessionCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).traineeDiscovery),
          centerTitle: true,
          actions: [_buildAppBarActions(context)],
        ),
        body: BlocListener<AuthSessionCubit, AuthSessionStates>(
          listener: (context, state) {
            if (state is AuthSessionSignOutSuccessState) {
              context.go(AppRoutes.signIn);
            } else if (state is AuthSessionDeleteSuccessState) {
              Message.showSuccess(context, S.of(context).accountDeletedSuccess);
              context.go(AppRoutes.signIn);
            } else if (state is AuthSessionErrorState) {
              Message.showError(context, state.errorMessage);
            }
          },
          child: const SafeArea(child: TraineeDiscoveryBody()),
        ),
      ),
    );
  }

  Widget _buildAppBarActions(BuildContext context) {
    return Builder(
      builder: (ctx) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) {
            if (value == 'sign_out') {
              ctx.read<AuthSessionCubit>().signOut();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'sign_out',
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(S.of(context).signOut),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
