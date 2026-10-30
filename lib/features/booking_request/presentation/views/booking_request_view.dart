import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/booking_request_cubit/booking_request_cubit.dart';
import '../view_model/booking_request_cubit/booking_request_state.dart';
import '../widgets/booking_bottom_bar.dart';
import '../widgets/booking_request_body.dart';
import '../widgets/booking_success_dialog.dart';

class BookingRequestView extends StatelessWidget {
  final CoachProfileModel coach;

  const BookingRequestView({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingRequestCubit>()..init(coach),
      child: BlocConsumer<BookingRequestCubit, BookingRequestState>(
        listener: (context, state) {
          if (state.status == BookingRequestStatus.success) {
            BookingSuccessDialog.show(
              context,
              coachName: coach.name,
              onDismiss: () {
                if (context.mounted) {
                  context.go(AppRoutes.traineeHome);
                }
              },
            );
          } else if (state.status == BookingRequestStatus.error &&
              state.errorMessage != null) {
            Message.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          final cubit = context.read<BookingRequestCubit>();
          final isSubmitting = state.status == BookingRequestStatus.submitting;

          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).bookingRequestTitle),
              centerTitle: true,
            ),
            body: SafeArea(
              child: BookingRequestBody(
                coach: coach,
                state: state,
                cubit: cubit,
              ),
            ),
            bottomNavigationBar: BookingBottomBar(
              price: state.totalPrice,
              isMonthly: state.isMonthly,
              isSubmitEnabled: state.isSubmitReady,
              isSubmitting: isSubmitting,
              onSubmit: () {
                if (!state.isSubmitReady) {
                  if (state.selectedDate == null) {
                    Message.showWarning(context, S.of(context).pleaseSelectStartDate);
                  } else if (state.isSession && state.selectedSlot == null) {
                    Message.showWarning(context, S.of(context).pleaseSelectTimeSlot);
                  }
                  return;
                }
                cubit.submitBooking();
              },
            ),
          );
        },
      ),
    );
  }
}
