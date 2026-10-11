import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/widgets/availability_selector/availability_helper.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_availability_cubit/availability_validation_error.dart';
import '../view_model/coach_availability_cubit/coach_availability_cubit.dart';
import '../view_model/coach_availability_cubit/coach_availability_states.dart';
import '../widgets/coach_availability_body.dart';

class CoachAvailabilityView extends StatelessWidget {
  final String? coachUid;
  final bool isRootTab;

  const CoachAvailabilityView({
    super.key,
    this.coachUid,
    this.isRootTab = false,
  });

  void _handleValidation(
    BuildContext context,
    AvailabilityValidationError err,
  ) {
    final s = S.of(context);
    switch (err.type) {
      case AvailabilityErrorType.noActiveDays:
        Message.showError(context, s.errorNoWorkingDays);
      case AvailabilityErrorType.invalidTimeRange:
        final day = AvailabilityHelper.getDayFullName(context, err.day!);
        Message.showError(context, s.errorInvalidTimeRange(day));
      case AvailabilityErrorType.windowTooShort:
        final day = AvailabilityHelper.getDayFullName(context, err.day!);
        Message.showError(
          context,
          s.errorTimeWindowTooShort(day, err.requiredDurationMinutes ?? 60),
        );
      case AvailabilityErrorType.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = coachUid ?? getIt<AuthService>().currentUser?.uid ?? '';

    return BlocProvider(
      create: (_) => getIt<CoachAvailabilityCubit>()..loadAvailability(uid),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).manageAvailability),
          centerTitle: true,
          automaticallyImplyLeading: !isRootTab,
        ),
        body: BlocConsumer<CoachAvailabilityCubit, CoachAvailabilityState>(
          listener: (context, state) {
            if (state is CoachAvailabilityLoaded) {
              if (state.saveSuccess) {
                Message.showSuccess(
                  context,
                  S.of(context).availabilitySavedSuccess,
                );
                context.read<CoachAvailabilityCubit>().clearMessages();
              } else if (state.errorMessage != null) {
                Message.showError(context, state.errorMessage!);
                context.read<CoachAvailabilityCubit>().clearMessages();
              } else if (state.validationError != null) {
                _handleValidation(context, state.validationError!);
                context.read<CoachAvailabilityCubit>().clearMessages();
              } else if (state.infoMessage == 'applied_to_all') {
                Message.showSuccess(
                  context,
                  S.of(context).hoursAppliedToAllDays,
                );
                context.read<CoachAvailabilityCubit>().clearMessages();
              }
            } else if (state is CoachAvailabilityFailure) {
              Message.showError(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is CoachAvailabilityLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CoachAvailabilityFailure) {
              return Center(
                child: TextButton.icon(
                  onPressed: () => context
                      .read<CoachAvailabilityCubit>()
                      .loadAvailability(uid),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(S.of(context).errorLoadingCoachProfile),
                ),
              );
            }
            if (state is CoachAvailabilityLoaded) {
              return CoachAvailabilityBody(
                state: state,
                cubit: context.read<CoachAvailabilityCubit>(),
                coachUid: uid,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
