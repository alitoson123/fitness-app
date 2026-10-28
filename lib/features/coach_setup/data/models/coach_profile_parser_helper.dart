import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/day_availability.dart';

abstract class CoachProfileParserHelper {
  static double parsePrice(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) {
      final parsed = double.tryParse(val);
      if (parsed != null) return parsed;
    }
    return 0.0;
  }

  static bool isValidPrice(double? price) {
    return price != null && price > 0;
  }

  static List<String> parseList(dynamic val) {
    if (val is List) return val.map((e) => e.toString()).toList();
    return const [];
  }

  static DateTime? parseDateTime(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val);
    return null;
  }

  static List<DayAvailability> parseAvailability(dynamic val) {
    if (val is List) {
      return val
          .whereType<Map>()
          .map((e) => DayAvailability.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
    return const [];
  }

  static Map<String, dynamic>? parseMap(dynamic val) {
    if (val is Map) {
      return Map<String, dynamic>.from(val);
    }
    return null;
  }
}
