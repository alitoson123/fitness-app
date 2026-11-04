import 'package:fitness_app/features/coach_setup/data/models/sport_location_model.dart';

class CoachSetupLocationHelper {
  static String normalize(String sport) =>
      sport.toLowerCase().replaceAll(' ', '_').trim();

  static List<SportLocationModel> syncOnAddSport(
    List<SportLocationModel> current,
    String sport,
  ) {
    final target = normalize(sport);
    final exists = current.any((s) => normalize(s.sport) == target);
    if (exists) return current;
    return List<SportLocationModel>.from(current)
      ..add(SportLocationModel(sport: sport));
  }

  static List<SportLocationModel> syncOnRemoveSport(
    List<SportLocationModel> current,
    String sport,
  ) {
    final target = normalize(sport);
    return current.where((s) => normalize(s.sport) != target).toList();
  }

  static List<SportLocationModel> toggleOnline(
    List<SportLocationModel> current,
    String sport,
    bool isOnline,
  ) {
    final target = normalize(sport);
    final idx = current.indexWhere((s) => normalize(s.sport) == target);
    if (idx < 0) return current;
    final updated = List<SportLocationModel>.from(current);
    updated[idx] = updated[idx].copyWith(isOnline: isOnline);
    return updated;
  }

  static List<SportLocationModel> addLocation(
    List<SportLocationModel> current,
    String sport,
    String locationName,
  ) {
    final trimmed = locationName.trim();
    if (trimmed.isEmpty) return current;
    final target = normalize(sport);
    final idx = current.indexWhere((s) => normalize(s.sport) == target);
    if (idx < 0) return current;
    final item = current[idx];
    if (item.locations.contains(trimmed)) return current;
    final updatedLocs = List<String>.from(item.locations)..add(trimmed);
    final updated = List<SportLocationModel>.from(current);
    updated[idx] = item.copyWith(locations: updatedLocs);
    return updated;
  }

  static List<SportLocationModel> removeLocation(
    List<SportLocationModel> current,
    String sport,
    int index,
  ) {
    final target = normalize(sport);
    final idx = current.indexWhere((s) => normalize(s.sport) == target);
    if (idx < 0) return current;
    final item = current[idx];
    if (index < 0 || index >= item.locations.length) return current;
    final updatedLocs = List<String>.from(item.locations)..removeAt(index);
    final updated = List<SportLocationModel>.from(current);
    updated[idx] = item.copyWith(locations: updatedLocs);
    return updated;
  }

  static SportLocationModel? getLocationConfig(
    List<SportLocationModel> current,
    String sport,
  ) {
    final target = normalize(sport);
    for (final loc in current) {
      if (normalize(loc.sport) == target) return loc;
    }
    return null;
  }
}
