import 'package:fitness_app/core/locator_service/service_locator.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/view_model/coach_profile_details_cubit/coach_profile_details_cubit.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/view_model/coach_profile_details_cubit/coach_profile_details_states.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/widgets/coach_details_body.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/widgets/coach_details_error_state.dart';
import 'package:fitness_app/features/coach_profile_details/presentation/widgets/request_training_button.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachDetailsView extends StatelessWidget {
  final CoachProfileModel? initialCoach;
  final String? coachUid;

  const CoachDetailsView({
    super.key,
    this.initialCoach,
    this.coachUid,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveUid = coachUid ?? initialCoach?.uid ?? '';

    return BlocProvider(
      create: (_) => getIt<CoachProfileDetailsCubit>()
        ..loadCoachDetails(
          coachUid: effectiveUid,
          initialCoach: initialCoach,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).coachProfileDetails),
          centerTitle: true,
        ),
        body: BlocBuilder<CoachProfileDetailsCubit, CoachProfileDetailsState>(
          builder: (context, state) {
            if (state is CoachProfileDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CoachProfileDetailsError) {
              return CoachDetailsErrorState(
                message: state.errorMessage,
                onRetry: () => context
                    .read<CoachProfileDetailsCubit>()
                    .loadCoachDetails(
                      coachUid: effectiveUid,
                      initialCoach: initialCoach,
                    ),
              );
            }

            if (state is CoachProfileDetailsLoaded) {
              return CoachDetailsBody(
                coach: state.coach,
                onRefresh: () => context
                    .read<CoachProfileDetailsCubit>()
                    .refresh(effectiveUid),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar:
            BlocBuilder<CoachProfileDetailsCubit, CoachProfileDetailsState>(
          builder: (context, state) {
            if (state is CoachProfileDetailsLoaded) {
              return RequestTrainingButton(coach: state.coach);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
