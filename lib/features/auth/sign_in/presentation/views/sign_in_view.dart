import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/helpers/message.dart';
import '../../../../../core/locator_service/service_locator.dart';
import '../../../../../core/navigator/app_routes.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../generated/l10n.dart';
import '../view_model/sign_in_cubit/sign_in_cubit.dart';
import '../view_model/sign_in_cubit/sign_in_states.dart';
import '../widgets/sign_in_view_body.dart';

class SignInView extends StatelessWidget {
  final (String email, String password)? initialParams;

  const SignInView({
    super.key,
    this.initialParams,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<SignInCubit, SignInStates>(
          listener: (context, state) {
            if (state is SignInSuccessState) {
              Message.showSuccess(
                context,
                S.of(context).welcomeBackUser(state.user.name),
              );
              if (!state.user.hasSelectedRole) {
                context.go(AppRoutes.chooseRole);
              } else if (state.user.isCoach) {
                context.go(AppRoutes.coachDashboard);
              } else {
                context.go(AppRoutes.traineeHome);
              }
            } else if (state is SignInEmailNotVerifiedState) {
              Message.showAppDialog(
                context: context,
                type: DialogType.warning,
                title: S.of(context).emailVerificationRequired,
                message: S.of(context).emailVerificationMessage,
                isVerifyButton: true,
                verifyButtonText: S.of(context).resendEmail,
                onVerifyPressed: () {
                  context.read<SignInCubit>().resendVerificationEmail();
                },
              );
            } else if (state is SignInVerificationEmailSentState) {
              Message.showSuccess(
                context,
                S.of(context).verificationEmailSent,
              );
            } else if (state is SignInErrorState) {
              Message.showAppDialog(
                context: context,
                type: DialogType.error,
                message: state.errMessage,
              );
            }
          },
          builder: (context, state) {
            return SignInViewBody(
              isLoading: state is SignInLoadingState,
              initialParams: initialParams,
            );
          },
        ),
      ),
    );
  }
}
