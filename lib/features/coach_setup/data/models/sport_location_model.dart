import 'package:flutter/foundation.dart';

class SportLocationModel {
  final String sport;
  final bool isOnline;
  final List<String> locations;

  const SportLocationModel({
    required this.sport,
    this.isOnline = false,
    this.locations = const [],
  });

  bool get hasPhysicalLocations => locations.isNotEmpty;
  bool get isValid => isOnline || locations.isNotEmpty;
  bool get hasMultipleLocations => locations.length > 1;

  factory SportLocationModel.fromMap(Map<String, dynamic> map) {
    final rawLocations = map['locations'];
    final parsedLocations = rawLocations is List
        ? rawLocations
              .map((e) => e.toString().trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : const <String>[];

    return SportLocationModel(
      sport: map['sport'] as String? ?? '',
      isOnline: map['isOnline'] as bool? ?? false,
      locations: parsedLocations,
    );
  }

  Map<String, dynamic> toMap() => {
    'sport': sport,
    'isOnline': isOnline,
    'locations': locations,
  };

  SportLocationModel copyWith({
    String? sport,
    bool? isOnline,
    List<String>? locations,
  }) {
    return SportLocationModel(
      sport: sport ?? this.sport,
      isOnline: isOnline ?? this.isOnline,
      locations: locations ?? this.locations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportLocationModel &&
          runtimeType == other.runtimeType &&
          sport == other.sport &&
          isOnline == other.isOnline &&
          listEquals(locations, other.locations);

  @override
  int get hashCode =>
      sport.hashCode ^ isOnline.hashCode ^ Object.hashAll(locations);

  @override
  String toString() =>
      'SportLocationModel(sport: $sport, isOnline: $isOnline, locations: $locations)';
}
