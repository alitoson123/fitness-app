import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import '../widgets/trainee_bookings_body.dart';

class TraineeBookingsView extends StatelessWidget {
  const TraineeBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final user = getIt<AuthService>().currentUser;
    final uid = user?.uid ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => getIt<TraineeBookingsCubit>()..listenToBookings(uid),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          title: Text(s.myBookings),
          centerTitle: false,
        ),
        body: TraineeBookingsBody(traineeUid: uid),
      ),
    );
  }
}
