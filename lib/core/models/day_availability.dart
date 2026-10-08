import 'package:flutter/material.dart';

enum DayOfWeek {
  saturday,
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}

class DayAvailability {
  final DayOfWeek day;
  final bool isAvailable;
  final TimeOfDay fromTime;
  final TimeOfDay toTime;

  const DayAvailability({
    required this.day,
    this.isAvailable = false,
    this.fromTime = const TimeOfDay(hour: 17, minute: 0),
    this.toTime = const TimeOfDay(hour: 21, minute: 0),
  });

  DayAvailability copyWith({
    DayOfWeek? day,
    bool? isAvailable,
    TimeOfDay? fromTime,
    TimeOfDay? toTime,
  }) {
    return DayAvailability(
      day: day ?? this.day,
      isAvailable: isAvailable ?? this.isAvailable,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day.name,
      'isAvailable': isAvailable,
      'fromHour': fromTime.hour,
      'fromMinute': fromTime.minute,
      'toHour': toTime.hour,
      'toMinute': toTime.minute,
    };
  }

  factory DayAvailability.fromMap(Map<String, dynamic> map) {
    final dayName = map['day'] as String? ?? 'monday';
    final day = DayOfWeek.values.firstWhere(
      (d) => d.name == dayName,
      orElse: () => DayOfWeek.monday,
    );
    return DayAvailability(
      day: day,
      isAvailable: map['isAvailable'] as bool? ?? false,
      fromTime: TimeOfDay(
        hour: map['fromHour'] as int? ?? 17,
        minute: map['fromMinute'] as int? ?? 0,
      ),
      toTime: TimeOfDay(
        hour: map['toHour'] as int? ?? 21,
        minute: map['toMinute'] as int? ?? 0,
      ),
    );
  }

  static List<DayAvailability> defaultSchedule() {
    return [
      const DayAvailability(day: DayOfWeek.saturday, isAvailable: true),
      const DayAvailability(day: DayOfWeek.sunday, isAvailable: true),
      const DayAvailability(day: DayOfWeek.monday, isAvailable: false),
      const DayAvailability(day: DayOfWeek.tuesday, isAvailable: false),
      const DayAvailability(day: DayOfWeek.wednesday, isAvailable: true),
      const DayAvailability(day: DayOfWeek.thursday, isAvailable: true),
      const DayAvailability(day: DayOfWeek.friday, isAvailable: false),
    ];
  }
}
