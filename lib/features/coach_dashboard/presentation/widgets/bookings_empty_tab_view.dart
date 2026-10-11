import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_bookings_cubit/coach_bookings_states.dart';
import 'empty_state_view.dart';

class BookingsEmptyTabView extends StatelessWidget {
  final CoachBookingTab tab;

  const BookingsEmptyTabView({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final (icon, title, desc) = switch (tab) {
      CoachBookingTab.pending => (
          Icons.inbox_rounded,
          s.noPendingRequestsTitle,
          s.noPendingRequestsDesc,
        ),
      CoachBookingTab.confirmed => (
          Icons.event_available_rounded,
          s.noConfirmedSessionsTitle,
          s.noConfirmedSessionsDesc,
        ),
      CoachBookingTab.past => (
          Icons.history_rounded,
          s.noPastSessionsTitle,
          s.noPastSessionsDesc,
        ),
    };

    return EmptyStateView(
      icon: icon,
      title: title,
      description: desc,
    );
  }
}
