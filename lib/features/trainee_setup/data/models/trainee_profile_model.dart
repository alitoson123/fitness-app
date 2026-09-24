import 'package:cloud_firestore/cloud_firestore.dart';

class TraineeProfileModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String role;
  final String gender;
  final String location;
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
    this.gender = '',
    this.location = '',
    this.sports = const [],
    this.level = '',
    this.goal = '',
    this.isProfileCompleted = false,
    this.updatedAt,
  });

  factory TraineeProfileModel.fromJson(Map<String, dynamic> json, {String? uid}) {
    return TraineeProfileModel(
      uid: uid ?? json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'trainee',
      gender: json['gender'] as String? ?? '',
      location: json['location'] as String? ?? '',
      sports: (json['sports'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      level: json['level'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      isProfileCompleted: json['isProfileCompleted'] as bool? ?? json['isCompleted'] as bool? ?? false,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      if (email.isNotEmpty) 'email': email,
      'role': role,
      'gender': gender,
      'location': location,
      'sports': sports,
      'level': level,
      'goal': goal,
      'isProfileCompleted': isProfileCompleted,
      if (photoUrl != null && photoUrl!.isNotEmpty) 'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  TraineeProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? role,
    String? gender,
    String? location,
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
      gender: gender ?? this.gender,
      location: location ?? this.location,
      sports: sports ?? this.sports,
      level: level ?? this.level,
      goal: goal ?? this.goal,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
