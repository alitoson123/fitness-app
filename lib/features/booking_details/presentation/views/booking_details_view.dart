import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../view_model/booking_details_args.dart';
import '../view_model/booking_details_cubit/booking_details_cubit.dart';
import '../view_model/booking_details_cubit/booking_details_state.dart';
import '../widgets/booking_details_app_bar.dart';
import '../widgets/booking_details_bottom_actions.dart';
import '../widgets/booking_details_notes_card.dart';
import '../widgets/booking_details_sessions_section.dart';
import '../widgets/booking_details_summary_card.dart';
import '../widgets/booking_details_user_card.dart';

class BookingDetailsView extends StatelessWidget {
  final BookingDetailsArgs args;

  const BookingDetailsView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingDetailsCubit>(
      create: (_) => getIt<BookingDetailsCubit>()..init(args.booking),
      child: _BookingDetailsScaffold(isCoach: args.isCoach),
    );
  }
}

class _BookingDetailsScaffold extends StatelessWidget {
  final bool isCoach;

  const _BookingDetailsScaffold({required this.isCoach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final s = S.of(context);

    return BlocConsumer<BookingDetailsCubit, BookingDetailsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<BookingDetailsCubit>().clearMessages();
        }
        if (state.successMessage != null) {
          final message = switch (state.successMessage!) {
            'accepted' => s.requestAcceptedSuccess,
            'rejected' => s.requestRejectedSuccess,
            'rescheduled' => isCoach
                ? s.rescheduleRequestedSuccess
                : s.rescheduleRequestedCoachSuccess,
            'reschedule_accepted' => s.rescheduleAcceptedSuccess,
            'reschedule_declined' => s.rescheduleDeclinedMessage,
            'session_completed' => s.sessionCompleted,
            'booking_completed' => s.bookingMarkedCompleted,
            'booking_cancelled' => s.bookingCancelledSuccess,
            _ => state.successMessage!,
          };
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.success,
            ),
          );
          context.read<BookingDetailsCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        final booking = state.booking;
        if (booking == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.backgroundSecondary,
          appBar: BookingDetailsAppBar(booking: booking),
          bottomNavigationBar: BookingDetailsBottomActions(
            booking: booking,
            isCoach: isCoach,
            isActionInProgress: state.isActionInProgress,
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                BookingDetailsUserCard(booking: booking, isCoach: isCoach),
                SizedBox(height: 12.h),
                BookingDetailsSummaryCard(booking: booking),
                SizedBox(height: 12.h),
                BookingDetailsNotesCard(booking: booking),
                if (booking.isMonthly) ...[
                  SizedBox(height: 16.h),
                  BookingDetailsSessionsSection(
                    booking: booking,
                    isCoach: isCoach,
                    isActionInProgress: state.isActionInProgress,
                    actionSessionId: state.actionSessionId,
                  ),
                ],
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
