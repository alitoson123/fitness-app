import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoachSportsTags extends StatelessWidget {
  final List<String> sports;
  final bool isDark;
  final Color primary;

  const CoachSportsTags({
    super.key,
    required this.sports,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6.w,
      runSpacing: 6.h,
      children: sports.map((sport) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: AppRadius.fullAll,
            border: Border.all(
              color: primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Text(
            sport,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
