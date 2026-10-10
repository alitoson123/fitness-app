import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/l10n.dart';

class CoachCardRatingRow extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  final int yearsOfExperience;
  final Color primaryColor;
  final Color textSecondaryColor;

  const CoachCardRatingRow({
    super.key,
    required this.rating,
    required this.reviewsCount,
    required this.yearsOfExperience,
    required this.primaryColor,
    required this.textSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_rounded, size: 16.r, color: Colors.amber),
        SizedBox(width: 2.w),
        Text(
          rating > 0 ? rating.toStringAsFixed(1) : S.of(context).noReviewsYet,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        if (reviewsCount > 0) ...[
          SizedBox(width: 2.w),
          Text(
            '($reviewsCount)',
            style: TextStyle(fontSize: 11.sp, color: textSecondaryColor),
          ),
        ],
        SizedBox(width: 8.w),
        Container(
          width: 3.r,
          height: 3.r,
          decoration: BoxDecoration(
            color: textSecondaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          S.of(context).experienceYearsCount(yearsOfExperience),
          style: TextStyle(fontSize: 12.sp, color: textSecondaryColor),
        ),
      ],
    );
  }
}
