import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/theme/app_colors.dart';

enum OnboardingType {
  coaches,
  scheduling,
  analytics,
}

class OnboardingItemModel {
  final OnboardingType type;
  final String Function(BuildContext) getTitle;
  final String Function(BuildContext) getDescription;
  final String Function(BuildContext) getBadge;
  final IconData primaryIcon;
  final Color accentColor;

  const OnboardingItemModel({
    required this.type,
    required this.getTitle,
    required this.getDescription,
    required this.getBadge,
    required this.primaryIcon,
    required this.accentColor,
  });

  static List<OnboardingItemModel> get items => [
    OnboardingItemModel(
      type: OnboardingType.coaches,
      getTitle: (context) => S.of(context).onboardingTitle1,
      getDescription: (context) => S.of(context).onboardingDesc1,
      getBadge: (context) => S.of(context).onboardingBadge1,
      primaryIcon: Icons.sports_kabaddi_rounded,
      accentColor: AppColors.flameRed,
    ),
    OnboardingItemModel(
      type: OnboardingType.scheduling,
      getTitle: (context) => S.of(context).onboardingTitle2,
      getDescription: (context) => S.of(context).onboardingDesc2,
      getBadge: (context) => S.of(context).onboardingBadge2,
      primaryIcon: Icons.calendar_month_rounded,
      accentColor: AppColors.secondary,
    ),
    OnboardingItemModel(
      type: OnboardingType.analytics,
      getTitle: (context) => S.of(context).onboardingTitle3,
      getDescription: (context) => S.of(context).onboardingDesc3,
      getBadge: (context) => S.of(context).onboardingBadge3,
      primaryIcon: Icons.insights_rounded,
      accentColor: AppColors.primary400,
    ),
  ];
}
