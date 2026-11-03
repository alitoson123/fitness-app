import 'package:flutter/material.dart';
import '../helpers/training_insights_calculator.dart';
import 'training_insights_active_display.dart';
import 'training_insights_empty_state.dart';

class TrainingInsightsStatContent extends StatelessWidget {
  final int uniqueDays;
  final TrainingPeriod period;

  const TrainingInsightsStatContent({
    super.key,
    required this.uniqueDays,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    if (uniqueDays == 0) {
      return TrainingInsightsEmptyState(period: period);
    }
    return TrainingInsightsActiveDisplay(
      uniqueDays: uniqueDays,
      period: period,
    );
  }
}
