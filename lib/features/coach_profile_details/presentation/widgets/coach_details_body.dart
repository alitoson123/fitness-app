import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'coach_bio_section.dart';
import 'coach_credentials_section.dart';
import 'coach_pricing_card.dart';
import 'coach_profile_header.dart';
import 'coach_schedule_preview.dart';

class CoachDetailsBody extends StatelessWidget {
  final CoachProfileModel coach;
  final Future<void> Function() onRefresh;

  const CoachDetailsBody({
    super.key,
    required this.coach,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            CoachProfileHeader(coach: coach),
            SizedBox(height: 16.h),
            CoachPricingCard(coach: coach),
            SizedBox(height: 14.h),
            CoachBioSection(coach: coach),
            SizedBox(height: 14.h),
            CoachCredentialsSection(coach: coach),
            SizedBox(height: 14.h),
            CoachSchedulePreview(coach: coach),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
