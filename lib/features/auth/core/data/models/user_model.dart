import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String role; // 'trainee' | 'coach' | 'admin' | ''

  @HiveField(4)
  final String? photoUrl;

  @HiveField(5)
  final String status; // 'active' | 'suspended'

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.role = '',
    this.photoUrl,
    this.status = 'active',
  });

  bool get hasSelectedRole => role == 'trainee' || role == 'coach' || role == 'admin';
  bool get isCoach => role == 'coach';
  bool get isTrainee => role == 'trainee';
  bool get isAdmin => role == 'admin';

  factory UserModel.fromFirebase({
    required User user,
    String? nameOverride,
    String role = '',
    String? photoUrl,
    String status = 'active',
  }) {
    return UserModel(
      uid: user.uid,
      name: nameOverride ?? user.displayName ?? 'CoachHub User',
      email: user.email ?? '',
      role: role,
      photoUrl: photoUrl ?? user.photoURL,
      status: status,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? role,
    String? photoUrl,
    String? status,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
    );
  }
}
