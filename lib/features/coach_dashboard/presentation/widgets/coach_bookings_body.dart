import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../helpers/coach_booking_date_helper.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_cubit.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_states.dart';
import 'booking_card.dart';
import 'bookings_empty_tab_view.dart';
import 'bookings_group_header.dart';
import 'bookings_skeleton.dart';
import 'bookings_tab_bar.dart';
import 'reject_booking_dialog.dart';
import 'reschedule_booking_sheet.dart';

class CoachBookingsBody extends StatelessWidget {
  const CoachBookingsBody({super.key});

  void _handleReject(
    BuildContext context,
    BookingModel booking,
    CoachBookingsCubit cubit,
  ) {
    RejectBookingDialog.show(
      context: context,
      booking: booking,
      onConfirm: (reason) => cubit.rejectBooking(booking.id, reason: reason),
    );
  }

  void _handleReschedule(
    BuildContext context,
    BookingModel booking,
    CoachBookingsCubit cubit,
  ) {
    RescheduleBookingSheet.show(
      context: context,
      booking: booking,
      onConfirm: (date, start, end, reason) => cubit.requestReschedule(
        booking: booking,
        proposedDate: date,
        proposedStartTime: start,
        proposedEndTime: end,
        reason: reason,
      ),
    );
  }

  String _getSummaryText(BuildContext context, CoachBookingsState state) {
    final s = S.of(context);
    return switch (state.selectedTab) {
      CoachBookingTab.pending => s.summaryPendingRequests(state.pendingCount),
      CoachBookingTab.confirmed => s.summaryConfirmedSessions(state.confirmedCount),
      CoachBookingTab.past => s.summaryPastSessions(state.pastCount),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CoachBookingsCubit>();
    final user = getIt<AuthService>().currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CoachBookingsCubit, CoachBookingsState>(
      builder: (context, state) {
        final currentBookings = state.currentTabBookings;
        final summary = _getSummaryText(context, state);
        final grouped = CoachBookingDateHelper.groupBookings(
          context,
          currentBookings,
          isPastTab: state.selectedTab == CoachBookingTab.past,
        );

        return RefreshIndicator(
          onRefresh: () async {
            if (user != null) cubit.listenToBookings(user.uid);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                BookingsTabBar(
                  selectedTab: state.selectedTab,
                  pendingCount: state.pendingCount,
                  confirmedCount: state.confirmedCount,
                  onTabChanged: cubit.changeTab,
                ),
                SizedBox(height: 12.h),
                if (!state.isLoading && currentBookings.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      summary,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                SizedBox(height: 8.h),
                if (state.isLoading)
                  const BookingsSkeleton()
                else if (currentBookings.isEmpty)
                  BookingsEmptyTabView(tab: state.selectedTab)
                else
                  ...grouped.entries.expand((entry) {
                    return [
                      BookingsGroupHeader(title: entry.key, count: entry.value.length),
                      ...entry.value.map(
                        (b) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: BookingCard(
                            key: ValueKey(b.id),
                            booking: b,
                            isActionInProgress: state.actionInProgressBookingId == b.id,
                            onAccept: () => cubit.acceptBooking(b.id),
                            onReject: () => _handleReject(context, b, cubit),
                            onReschedule: () => _handleReschedule(context, b, cubit),
                          ),
                        ),
                      ),
                    ];
                  }),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
