class BookingSessionModel {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  const BookingSessionModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status = 'scheduled',
  });

  factory BookingSessionModel.fromJson(Map<String, dynamic> json) {
    return BookingSessionModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      status: json['status'] as String? ?? 'scheduled',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }

  BookingSessionModel copyWith({
    String? id,
    String? date,
    String? startTime,
    String? endTime,
    String? status,
  }) {
    return BookingSessionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingSessionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      status.hashCode;
}

