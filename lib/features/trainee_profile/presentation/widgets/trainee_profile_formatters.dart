import 'package:flutter/material.dart';
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

  static String formatSport(BuildContext context, String sport) {
    final s = S.of(context);
    switch (sport.toLowerCase().replaceAll(' ', '_')) {
      case 'gym':
        return s.sportGym;
      case 'football':
        return s.sportFootball;
      case 'boxing':
        return s.sportBoxing;
      case 'swimming':
        return s.sportSwimming;
      case 'basketball':
        return s.sportBasketball;
      case 'tennis':
        return s.sportTennis;
      case 'running':
        return s.sportRunning;
      case 'cycling':
        return s.sportCycling;
      case 'yoga':
        return s.sportYoga;
      case 'martial_arts':
        return s.sportMartialArts;
      case 'volleyball':
        return s.sportVolleyball;
      case 'other':
        return s.sportOther;
      default:
        return sport;
    }
  }
}

