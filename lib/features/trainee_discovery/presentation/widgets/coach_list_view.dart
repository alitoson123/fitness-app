import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'coach_card.dart';

class CoachListView extends StatelessWidget {
  final List<CoachProfileModel> coaches;
  final ValueChanged<CoachProfileModel> onCoachTap;

  const CoachListView({
    super.key,
    required this.coaches,
    required this.onCoachTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: coaches.length,
      itemBuilder: (context, index) {
        final coach = coaches[index];
        return CoachCard(
          coach: coach,
          onTap: () => onCoachTap(coach),
        );
      },
    );
  }
}
