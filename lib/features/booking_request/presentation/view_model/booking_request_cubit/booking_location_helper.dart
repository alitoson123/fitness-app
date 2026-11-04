import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';

class BookingLocationHelper {
  static ({bool isOnline, String? location}) resolveInitialDelivery({
    required CoachProfileModel coach,
    required String sport,
  }) {
    final config = coach.getLocationConfigForSport(sport);
    if (config != null) {
      if (config.isOnline && config.locations.isEmpty) {
        return (isOnline: true, location: null);
      }
      if (!config.isOnline && config.locations.length == 1) {
        return (isOnline: false, location: config.locations.first);
      }
    }
    if (coach.sports.isEmpty && coach.sportLocations.isEmpty) {
      return (isOnline: true, location: null);
    }
    return (isOnline: false, location: null);
  }
}
