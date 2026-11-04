import 'package:flutter/material.dart';

/// Maps sport identifiers or display names to appropriate Material icons.
class SportIconHelper {
  const SportIconHelper._();

  static IconData getIcon(String sport) {
    switch (sport.toLowerCase().replaceAll(' ', '_').trim()) {
      case 'gym':
      case 'crossfit':
      case 'fitness':
      case 'bodybuilding':
        return Icons.fitness_center_rounded;
      case 'football':
      case 'soccer':
        return Icons.sports_soccer_rounded;
      case 'boxing':
        return Icons.sports_mma_rounded;
      case 'swimming':
        return Icons.pool_rounded;
      case 'basketball':
        return Icons.sports_basketball_rounded;
      case 'tennis':
      case 'padel':
      case 'badminton':
      case 'table_tennis':
        return Icons.sports_tennis_rounded;
      case 'running':
        return Icons.directions_run_rounded;
      case 'cycling':
        return Icons.directions_bike_rounded;
      case 'handball':
        return Icons.sports_handball_rounded;
      case 'martial_arts':
        return Icons.sports_martial_arts_rounded;
      case 'volleyball':
        return Icons.sports_volleyball_rounded;
      case 'yoga':
        return Icons.self_improvement_rounded;
      default:
        return Icons.sports_rounded;
    }
  }
}

