import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../view_model/choose_role_cubit/choose_role_cubit.dart';
import '../view_model/choose_role_cubit/choose_role_states.dart';
import 'widgets/role_card.dart';

class ChooseRoleView extends StatefulWidget {
  const ChooseRoleView({super.key});

  @override
  State<ChooseRoleView> createState() => _ChooseRoleViewState();
}

class _ChooseRoleViewState extends State<ChooseRoleView> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChooseRoleCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).chooseAccountType)),
        body: SafeArea(
          child: BlocConsumer<ChooseRoleCubit, ChooseRoleStates>(
            listener: (context, state) {
              if (state is ChooseRoleSuccessState) {
                if (state.role == 'coach') {
                  context.go(AppRoutes.coachDashboard);
                } else {
                  context.go(AppRoutes.traineeHome);
                }
              } else if (state is ChooseRoleErrorState) {
                Message.showError(context, state.errMessage);
              }
            },
            builder: (context, state) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
              final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
              final primaryAccent = Theme.of(context).colorScheme.primary;

              return Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.s4),
                    Text(
                      S.of(context).chooseYourRole,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.s2),
                    Text(
                      S.of(context).howWillYouUse,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.s8),
                    RoleCard(
                      title: S.of(context).iAmTrainee,
                      description: S.of(context).traineeDesc,
                      icon: Icons.directions_run_rounded,
                      accentColor: primaryAccent,
                      isSelected: _selectedRole == 'trainee',
                      onTap: () => setState(() => _selectedRole = 'trainee'),
                    ),
                    SizedBox(height: AppSpacing.s4),
                    RoleCard(
                      title: S.of(context).iAmCoach,
                      description: S.of(context).coachDesc,
                      icon: Icons.sports_rounded,
                      accentColor: AppColors.secondary,
                      isSelected: _selectedRole == 'coach',
                      onTap: () => setState(() => _selectedRole = 'coach'),
                    ),
                    const Spacer(),
                    AppButton(
                      label: S.of(context).continueButton,
                      fullWidth: true,
                      loading: state is ChooseRoleLoadingState,
                      onPressed: _selectedRole == null
                          ? null
                          : () {
                              context.read<ChooseRoleCubit>().saveUserRole(
                                    role: _selectedRole!,
                                  );
                            },
                    ),
                    SizedBox(height: AppSpacing.s6),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
