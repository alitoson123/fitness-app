import 'package:flutter/material.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../generated/l10n.dart';
import '../widgets/trainee_bookings_body.dart';

class TraineeBookingsPage extends StatelessWidget {
  const TraineeBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthService>().currentUser;
    final uid = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myBookings),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: TraineeBookingsBody(traineeUid: uid),
      ),
    );
  }
}
