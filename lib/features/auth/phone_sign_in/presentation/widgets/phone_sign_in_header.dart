import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/generated/l10n.dart';

class PhoneSignInHeader extends StatelessWidget {
  const PhoneSignInHeader({super.key});

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
            Icons.phone_iphone_rounded,
            color: theme.colorScheme.primary,
            size: 28.r,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          s.signInWithPhone,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          s.phoneSignInSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
