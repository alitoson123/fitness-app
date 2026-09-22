import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/helpers/message.dart';
import '../../../../../core/locator_service/service_locator.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../generated/l10n.dart';
import '../view_model/forget_password_cubit/forget_password_cubit.dart';
import '../view_model/forget_password_cubit/forget_password_states.dart';
import '../widgets/forget_password_view_body.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgetPasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.r),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccessState) {
              Message.showAppDialog(
                context: context,
                type: DialogType.success,
                title: S.of(context).resetLinkSent,
                message: S.of(context).resetLinkSentMessage,
                buttonText: S.of(context).backToSignIn,
                onVerifyPressed: () => context.pop(),
              );
            } else if (state is ForgetPasswordErrorState) {
              Message.showAppDialog(
                context: context,
                type: DialogType.error,
                message: state.errMessage,
              );
            }
          },
          builder: (context, state) {
            return ForgetPasswordViewBody(
              isLoading: state is ForgetPasswordLoadingState,
            );
          },
        ),
      ),
    );
  }
}
