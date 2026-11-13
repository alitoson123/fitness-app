import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../coach_dashboard/presentation/widgets/reschedule_booking_sheet.dart';
import '../view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import '../view_model/trainee_bookings_cubit/trainee_bookings_states.dart';
import 'trainee_booking_card.dart';
import 'trainee_bookings_tab_bar.dart';
import 'trainee_cancel_booking_dialog.dart';
import 'trainee_reject_reschedule_dialog.dart';

class TraineeBookingsBody extends StatelessWidget {
  final String traineeUid;

  const TraineeBookingsBody({super.key, required this.traineeUid});

  void _handleReschedule(
    BuildContext context,
    BookingModel booking,
    TraineeBookingsCubit cubit,
  ) {
    RescheduleBookingSheet.show(
      context: context,
      booking: booking,
      onConfirm: (date, start, end, reason, {sessionId}) =>
          booking.isMonthly && sessionId != null
              ? cubit.requestMonthlySessionReschedule(
                  bookingId: booking.id,
                  sessionId: sessionId,
                  proposedDate: date,
                  proposedStartTime: start,
                  proposedEndTime: end,
                  reason: reason,
                )
              : cubit.requestReschedule(
                  booking: booking,
                  proposedDate: date,
                  proposedStartTime: start,
                  proposedEndTime: end,
                  reason: reason,
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cubit = context.read<TraineeBookingsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<TraineeBookingsCubit, TraineeBookingsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
          cubit.clearMessages();
        }
        if (state.successMessage == 'reschedule_approved') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.rescheduleAcceptedSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          cubit.clearMessages();
        }
        if (state.successMessage == 'reschedule_rejected') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.rescheduleDeclinedMessage),
              backgroundColor: AppColors.primary,
            ),
          );
          cubit.clearMessages();
        }
        if (state.successMessage == 'booking_cancelled') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.bookingCancelledSuccess),
              backgroundColor: AppColors.primary,
            ),
          );
          cubit.clearMessages();
        }
        if (state.successMessage == 'rescheduled') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.rescheduleRequestedCoachSuccess),
              backgroundColor: AppColors.primary,
            ),
          );
          cubit.clearMessages();
        }
      },
      builder: (context, state) {
        final bookings = state.currentTabBookings;

        return RefreshIndicator(
          onRefresh: () async => cubit.listenToBookings(traineeUid),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                TraineeBookingsTabBar(
                  selectedTab: state.selectedTab,
                  activeCount: state.activeCount,
                  historyCount: state.historyCount,
                  onTabChanged: cubit.changeTab,
                ),
                SizedBox(height: 14.h),
                if (state.isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (bookings.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.h),
                      child: Text(
                        s.noBookingsFound,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ...bookings.map(
                    (b) => TraineeBookingCard(
                      key: ValueKey(b.id),
                      booking: b,
                      isActionInProgress:
                          state.actionInProgressBookingId == b.id,
                      onApproveReschedule: () => cubit.acceptReschedule(b),
                      onRejectReschedule: () =>
                          TraineeRejectRescheduleDialog.show(
                        context: context,
                        onConfirm: (reason) => cubit.declineReschedule(
                          b.id,
                          declineReason: reason,
                        ),
                      ),
                      onRebook: () => context.push(
                        AppRoutes.coachDetails,
                        extra: b.coachUid,
                      ),
                      onReschedule: () => _handleReschedule(context, b, cubit),
                      onCancel: () => TraineeCancelBookingDialog.show(
                        context: context,
                        onConfirm: (reason) =>
                            cubit.cancelBooking(b.id, reason: reason),
                      ),
                    ),
                  ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
