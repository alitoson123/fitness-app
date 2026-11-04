import 'package:flutter/material.dart';
import '../../../../core/constant/app_sports.dart';
import '../../../../generated/l10n.dart';

class TraineeProfileFormatters {
  const TraineeProfileFormatters._();

  static String formatLevel(BuildContext context, String level) {
    final s = S.of(context);
    switch (level.toLowerCase()) {
      case 'beginner':
        return s.beginner;
      case 'intermediate':
        return s.intermediate;
      case 'advanced':
        return s.advanced;
      default:
        return level.isNotEmpty ? level : s.notSpecified;
    }
  }

  static String formatGoal(BuildContext context, String goal) {
    final s = S.of(context);
    switch (goal.toLowerCase()) {
      case 'fitness':
        return s.generalFitness;
      case 'weight_loss':
        return s.weightLoss;
      case 'competition':
        return s.competitionPrep;
      case 'skill':
        return s.skillDevelopment;
      case 'fun':
        return s.funRecreation;
      default:
        return goal.isNotEmpty ? goal : s.notSpecified;
    }
  }

  static String formatGender(BuildContext context, String gender) {
    final s = S.of(context);
    switch (gender.toLowerCase()) {
      case 'male':
        return s.male;
      case 'female':
        return s.female;
      default:
        return gender.isNotEmpty ? gender : s.notSpecified;
    }
  }

  static String formatSport(BuildContext context, String sport) =>
      AppSports.getLocalizedSportName(context, sport);
}

