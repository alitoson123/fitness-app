import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_states.dart';
import 'trainee_home_actions.dart';
import 'trainee_home_header.dart';

class TraineeHomeBody extends StatelessWidget {
  const TraineeHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthSessionCubit>();

    return BlocBuilder<AuthSessionCubit, AuthSessionStates>(
      builder: (context, state) {
        final isLoading = state is AuthSessionLoadingState;
        final isDeleting = state is AuthSessionLoadingState && state.isDeleting;

        return SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const Spacer(),
                TraineeHomeHeader(email: cubit.currentUserEmail),
                const Spacer(),
                TraineeHomeActions(
                  isLoading: isLoading,
                  isDeleting: isDeleting,
                  onSignOut: () => cubit.signOut(),
                  onDeleteAccount: () => cubit.deleteAccount(),
                ),
                SizedBox(height: AppSpacing.s4),
              ],
            ),
          ),
        );
      },
    );
  }
}
