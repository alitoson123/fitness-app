import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_states.dart';
import 'stat_card.dart';

class CoachDashboardStats extends StatelessWidget {
  final CoachBookingsState state;
  final ValueChanged<CoachBookingTab> onSelectTab;

  const CoachDashboardStats({
    super.key,
    required this.state,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Row(
      children: [
        Expanded(
          child: StatCard(
            count: state.pendingCount,
            label: s.statPending,
            icon: Icons.hourglass_top_rounded,
            iconColor: AppColors.flameRed,
            isSelected: state.selectedTab == CoachBookingTab.pending,
            onTap: () => onSelectTab(CoachBookingTab.pending),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: StatCard(
            count: state.confirmedCount,
            label: s.statUpcoming,
            icon: Icons.event_available_rounded,
            iconColor: AppColors.success,
            isSelected: state.selectedTab == CoachBookingTab.confirmed,
            onTap: () => onSelectTab(CoachBookingTab.confirmed),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: StatCard(
            count: state.pastCount,
            label: s.statHistory,
            icon: Icons.history_rounded,
            iconColor: AppColors.darkTextSecondary,
            isSelected: state.selectedTab == CoachBookingTab.past,
            onTap: () => onSelectTab(CoachBookingTab.past),
          ),
        ),
      ],
    );
  }
}
