import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/locator_service/service_locator.dart';
import '../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../coach_setup/data/data_source/coach_setup_local_data_source.dart';
import '../helpers/coach_booking_date_helper.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_cubit.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_states.dart';
import 'coach_dashboard_skeleton.dart';
import 'coach_dashboard_stats.dart';
import 'coach_welcome_header.dart';
import 'next_session_card.dart';
import 'pending_requests_preview.dart';
import 'quick_actions_section.dart';
import 'reject_booking_dialog.dart';
import 'week_strip.dart';

class CoachDashboardBody extends StatefulWidget {
  final ValueChanged<int> onNavigateToTab;

  const CoachDashboardBody({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  State<CoachDashboardBody> createState() => _CoachDashboardBodyState();
}

class _CoachDashboardBodyState extends State<CoachDashboardBody> {
  String? _coachName;

  @override
  void initState() {
    super.initState();
    _loadCoachName();
  }

  Future<void> _loadCoachName() async {
    final cached = await getIt<CoachSetupLocalDataSource>().getCachedProfile();
    if (mounted && cached != null && cached.name.isNotEmpty) {
      setState(() => _coachName = cached.name);
    }
  }

  void _handleReject(BookingModel booking, CoachBookingsCubit cubit) {
    RejectBookingDialog.show(
      context: context,
      booking: booking,
      onConfirm: (reason) => cubit.rejectBooking(booking.id, reason: reason),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthSessionCubit>();
    final bookingsCubit = context.read<CoachBookingsCubit>();
    final user = getIt<AuthService>().currentUser;
    final name = _coachName ?? user?.displayName;

    return BlocBuilder<CoachBookingsCubit, CoachBookingsState>(
      builder: (context, state) {
        if (state.isLoading && state.allBookings.isEmpty) {
          return const SafeArea(child: CoachDashboardSkeleton());
        }

        final nextSession = CoachBookingDateHelper.getNearestUpcomingSession(
          state.confirmedBookings,
        );
        final earnings = CoachBookingDateHelper.calculateMonthEarnings(
          state.allBookings,
        );
        final currency = state.allBookings.isNotEmpty
            ? state.allBookings.first.currency
            : 'SAR';

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              if (user != null) {
                bookingsCubit.listenToBookings(user.uid);
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.s2),
                  CoachWelcomeHeader(
                    coachName: name,
                    phoneNumber:
                        authCubit.currentUserPhoneNumber ?? user?.phoneNumber,
                  ),
                  SizedBox(height: AppSpacing.s3),
                  CoachDashboardStats(
                    state: state,
                    onSelectTab: (tab) {
                      bookingsCubit.changeTab(tab);
                      widget.onNavigateToTab(1);
                    },
                  ),
                  SizedBox(height: AppSpacing.s3),
                  NextSessionCard(
                    session: nextSession,
                    onSetAvailability: () => widget.onNavigateToTab(2),
                    onTap: () {
                      bookingsCubit.changeTab(CoachBookingTab.confirmed);
                      widget.onNavigateToTab(1);
                    },
                  ),
                  SizedBox(height: AppSpacing.s3),
                  PendingRequestsPreview(
                    pendingBookings: state.pendingBookings,
                    actionInProgressId: state.actionInProgressBookingId,
                    onAccept: bookingsCubit.acceptBooking,
                    onReject: (b) => _handleReject(b, bookingsCubit),
                    onViewAll: () {
                      bookingsCubit.changeTab(CoachBookingTab.pending);
                      widget.onNavigateToTab(1);
                    },
                  ),
                  SizedBox(height: AppSpacing.s3),
                  WeekStrip(bookings: state.allBookings),
                  SizedBox(height: AppSpacing.s3),
                  QuickActionsSection(
                    onManageAvailability: () => widget.onNavigateToTab(2),
                    onViewBookings: () => widget.onNavigateToTab(1),
                    monthlyEarnings: earnings,
                    currency: currency,
                  ),
                  SizedBox(height: AppSpacing.s4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
