import 'package:flutter/material.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'next_session_empty_card.dart';
import 'next_session_hero_card.dart';

class NextSessionCard extends StatelessWidget {
  final BookingModel? session;
  final VoidCallback onSetAvailability;
  final VoidCallback? onTap;

  const NextSessionCard({
    super.key,
    required this.session,
    required this.onSetAvailability,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return NextSessionEmptyCard(onSetAvailability: onSetAvailability);
    }
    return NextSessionHeroCard(session: session!, onTap: onTap);
  }
}
