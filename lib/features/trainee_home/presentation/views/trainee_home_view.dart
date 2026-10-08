import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/helpers/message.dart';
import '../../../../../core/locator_service/service_locator.dart';
import '../../../../../core/navigator/app_routes.dart';
import '../../../../../generated/l10n.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_states.dart';
import '../widgets/trainee_home_body.dart';

class TraineeHomeView extends StatelessWidget {
  const TraineeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthSessionCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).traineeDiscovery),
          centerTitle: true,
        ),
        body: BlocListener<AuthSessionCubit, AuthSessionStates>(
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
          child: const TraineeHomeBody(),
        ),
      ),
    );
  }
}
