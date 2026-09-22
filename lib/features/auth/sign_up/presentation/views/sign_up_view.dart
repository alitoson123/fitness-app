import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/helpers/message.dart';
import '../../../../../core/locator_service/service_locator.dart';
import '../../../../../core/navigator/app_routes.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../generated/l10n.dart';
import '../view_model/sign_up_cubit/sign_up_cubit.dart';
import '../view_model/sign_up_cubit/sign_up_states.dart';
import '../widgets/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<SignUpCubit, SignUpStates>(
          listener: (context, state) {
            if (state is SignUpSuccessState) {
              Message.showAppDialog(
                context: context,
                type: DialogType.success,
                title: S.of(context).accountCreated,
                message: S.of(context).accountCreatedMessage,
                buttonText: S.of(context).goToSignIn,
                onVerifyPressed: () {
                  context.pushReplacement(AppRoutes.signIn);
                },
              );
            } else if (state is SignUpErrorState) {
              Message.showAppDialog(
                context: context,
                type: DialogType.error,
                message: state.errMessage,
              );
            }
          },
          builder: (context, state) {
            return SignUpViewBody(
              isLoading: state is SignUpLoadingState,
            );
          },
        ),
      ),
    );
  }
}
