import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0, defaultValue: '')
  final String uid;

  @HiveField(1, defaultValue: '')
  final String name;

  @HiveField(3, defaultValue: '')
  final String role; // 'trainee' | 'coach' | 'admin' | ''

  @HiveField(4, defaultValue: 'active')
  final String status; // 'active' | 'suspended'

  @HiveField(5, defaultValue: '')
  final String phoneNumber;

  @HiveField(6, defaultValue: '')
  final String countryCode;

  UserModel({
    required this.uid,
    this.name = '',
    this.role = '',
    this.status = 'active',
    this.phoneNumber = '',
    this.countryCode = '',
  });

  bool get hasSelectedRole =>
      role == 'trainee' || role == 'coach' || role == 'admin';
  bool get isCoach => role == 'coach';
  bool get isTrainee => role == 'trainee';
  bool get isAdmin => role == 'admin';

  factory UserModel.fromFirebase({
    required User user,
    String? nameOverride,
    String role = '',
    String status = 'active',
    String countryCode = '',
  }) {
    return UserModel(
      uid: user.uid,
      name: nameOverride ?? user.displayName ?? '',
      role: role,
      status: status,
      phoneNumber: user.phoneNumber ?? '',
      countryCode: countryCode,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'role': role,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? role,
    String? status,
    String? phoneNumber,
    String? countryCode,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
