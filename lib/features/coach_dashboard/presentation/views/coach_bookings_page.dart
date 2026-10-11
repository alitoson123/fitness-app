import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../widgets/coach_bookings_body.dart';

class CoachBookingsPage extends StatelessWidget {
  const CoachBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).coachBookingsTitle),
        centerTitle: true,
      ),
      body: const CoachBookingsBody(),
    );
  }
}
