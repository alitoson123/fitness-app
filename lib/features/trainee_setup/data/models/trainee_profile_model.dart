import 'package:cloud_firestore/cloud_firestore.dart';

class TraineeProfileModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String role;
  final String country;
  final String city;
  final int age;
  final String gender;
  final List<String> sports;
  final String level;
  final String goal;
  final bool isProfileCompleted;
  final DateTime? updatedAt;

  const TraineeProfileModel({
    required this.uid,
    this.name = '',
    this.email = '',
    this.photoUrl,
    this.role = 'trainee',
    this.country = '',
    this.city = '',
    this.age = 0,
    this.gender = '',
    this.sports = const [],
    this.level = '',
    this.goal = '',
    this.isProfileCompleted = false,
    this.updatedAt,
  });

  factory TraineeProfileModel.fromJson(
    Map<String, dynamic> json, {
    String? uid,
  }) {
    return TraineeProfileModel(
      uid: uid ?? json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'trainee',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? '',
      sports:
          (json['sports'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      level: json['level'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val);
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      if (email.isNotEmpty) 'email': email,
      'role': role,
      'country': country,
      'city': city,
      'age': age,
      'gender': gender,
      'sports': sports,
      'level': level,
      'goal': goal,
      'isProfileCompleted': isProfileCompleted,
      if (photoUrl != null && photoUrl!.isNotEmpty) 'photoUrl': photoUrl,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  TraineeProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? role,
    String? country,
    String? city,
    int? age,
    String? gender,
    List<String>? sports,
    String? level,
    String? goal,
    bool? isProfileCompleted,
    DateTime? updatedAt,
  }) {
    return TraineeProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      country: country ?? this.country,
      city: city ?? this.city,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      sports: sports ?? this.sports,
      level: level ?? this.level,
      goal: goal ?? this.goal,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
