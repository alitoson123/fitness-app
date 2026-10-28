import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/generated/l10n.dart';

class OtpVerificationHeader extends StatelessWidget {
  final String maskedPhoneNumber;
  final VoidCallback onEditNumber;

  const OtpVerificationHeader({
    super.key,
    required this.maskedPhoneNumber,
    required this.onEditNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56.r,
          height: 56.r,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(30),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.phone_android_rounded,
            color: theme.colorScheme.primary,
            size: 28.r,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          s.otpVerification,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6.w,
          children: [
            Text(
              s.otpVerificationSubtitle(maskedPhoneNumber),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
                height: 1.4,
              ),
            ),
            InkWell(
              onTap: onEditNumber,
              borderRadius: BorderRadius.circular(4.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Text(
                  s.editNumber,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
