import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/features/auth/core/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel Serialization Tests', () {
    test('toMap includes both createdAt and updatedAt timestamps', () {
      final user = UserModel(
        uid: 'user_test_1',
        name: 'Ahmed Coach',
        phoneNumber: '+201012345678',
        countryCode: '+20',
        role: 'coach',
        status: 'active',
      );

      final map = user.toMap();

      expect(map['uid'], equals('user_test_1'));
      expect(map['name'], equals('Ahmed Coach'));
      expect(map['phoneNumber'], equals('+201012345678'));
      expect(map['countryCode'], equals('+20'));
      expect(map['role'], equals('coach'));
      expect(map['status'], equals('active'));
      expect(map['createdAt'], isA<FieldValue>());
      expect(map['updatedAt'], isA<FieldValue>());
    });

    test('fromJson parses fields correctly', () {
      final json = {
        'uid': 'user_test_2',
        'name': 'Sara Trainee',
        'phoneNumber': '+96171123456',
        'countryCode': '+961',
        'role': 'trainee',
        'status': 'active',
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, equals('user_test_2'));
      expect(user.name, equals('Sara Trainee'));
      expect(user.phoneNumber, equals('+96171123456'));
      expect(user.countryCode, equals('+961'));
      expect(user.role, equals('trainee'));
      expect(user.status, equals('active'));
      expect(user.isTrainee, isTrue);
      expect(user.isCoach, isFalse);
    });
  });
}
