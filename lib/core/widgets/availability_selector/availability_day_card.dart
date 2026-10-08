import 'package:flutter/material.dart';
import '../../models/day_availability.dart';
import 'available_day_card.dart';
import 'unavailable_day_card.dart';

class AvailabilityDayCard extends StatelessWidget {
  final DayAvailability availability;
  final bool isDark;
  final Color primaryColor;
  final ValueChanged<bool> onToggleAvailable;
  final ValueChanged<TimeOfDay> onFromTimeChanged;
  final ValueChanged<TimeOfDay> onToTimeChanged;

  const AvailabilityDayCard({
    super.key,
    required this.availability,
    required this.isDark,
    required this.primaryColor,
    required this.onToggleAvailable,
    required this.onFromTimeChanged,
    required this.onToTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!availability.isAvailable) {
      return UnavailableDayCard(
        availability: availability,
        isDark: isDark,
        onTap: () => onToggleAvailable(true),
      );
    }
    return AvailableDayCard(
      availability: availability,
      isDark: isDark,
      primaryColor: primaryColor,
      onDisable: () => onToggleAvailable(false),
      onFromTimeChanged: onFromTimeChanged,
      onToTimeChanged: onToTimeChanged,
    );
  }
}
