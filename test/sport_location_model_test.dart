import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/sport_location_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SportLocationModel Tests', () {
    test('default values are isOnline false and empty locations', () {
      const model = SportLocationModel(sport: 'football');
      expect(model.sport, 'football');
      expect(model.isOnline, isFalse);
      expect(model.locations, isEmpty);
      expect(model.hasPhysicalLocations, isFalse);
      expect(model.isValid, isFalse);
      expect(model.hasMultipleLocations, isFalse);
    });

    test('isValid is true if online or physical locations exist', () {
      const onlineOnly = SportLocationModel(sport: 'fitness', isOnline: true);
      expect(onlineOnly.isValid, isTrue);

      const locationOnly = SportLocationModel(
        sport: 'tennis',
        locations: ['Gezira Club'],
      );
      expect(locationOnly.isValid, isTrue);
      expect(locationOnly.hasPhysicalLocations, isTrue);
      expect(locationOnly.hasMultipleLocations, isFalse);

      const multiLocation = SportLocationModel(
        sport: 'swimming',
        locations: ['Club A', 'Club B'],
      );
      expect(multiLocation.hasMultipleLocations, isTrue);
    });

    test('fromMap and toMap serialize properly', () {
      final map = {
        'sport': 'padel',
        'isOnline': true,
        'locations': ['Smouha Club', 'Shooting Club'],
      };
      final model = SportLocationModel.fromMap(map);
      expect(model.sport, 'padel');
      expect(model.isOnline, isTrue);
      expect(model.locations, ['Smouha Club', 'Shooting Club']);

      final serialized = model.toMap();
      expect(serialized['sport'], 'padel');
      expect(serialized['isOnline'], isTrue);
      expect(serialized['locations'], ['Smouha Club', 'Shooting Club']);
    });

    test('value equality and copyWith work correctly', () {
      const m1 = SportLocationModel(
        sport: 'running',
        isOnline: true,
        locations: ['Track A'],
      );
      final m2 = m1.copyWith();
      expect(m1, equals(m2));
      expect(m1.hashCode, equals(m2.hashCode));

      final m3 = m1.copyWith(isOnline: false);
      expect(m1 == m3, isFalse);
    });
  });

  group('CoachProfileModel & BookingModel Schema Evolution Tests', () {
    test(
      'CoachProfileModel parses sportLocations and preserves backward compatibility',
      () {
        final legacyJson = {
          'uid': 'coach_1',
          'name': 'Coach John',
          'sports': ['Football', 'Padel'],
        };
        final legacyCoach = CoachProfileModel.fromJson(legacyJson);
        expect(legacyCoach.sportLocations.length, 2);
        expect(legacyCoach.sportLocations.first.sport, 'Football');
        expect(legacyCoach.sportLocations.first.isOnline, isTrue);

        final modernJson = {
          'uid': 'coach_2',
          'name': 'Coach Sarah',
          'sports': ['Tennis'],
          'sportLocations': [
            {
              'sport': 'Tennis',
              'isOnline': false,
              'locations': ['Gezira Club'],
            },
          ],
        };
        final modernCoach = CoachProfileModel.fromJson(modernJson);
        expect(modernCoach.sportLocations.length, 1);
        expect(modernCoach.sportLocations.first.isOnline, isFalse);
        expect(modernCoach.sportLocations.first.locations, ['Gezira Club']);
        expect(
          modernCoach.getLocationConfigForSport('Tennis')?.hasPhysicalLocations,
          isTrue,
        );
      },
    );

    test('BookingModel serializes trainingLocation and isOnline', () {
      final bookingJson = {
        'id': 'b1',
        'coachUid': 'c1',
        'traineeUid': 't1',
        'sport': 'Padel',
        'date': '2026-11-10',
        'startTime': '10:00 AM',
        'endTime': '11:00 AM',
        'trainingLocation': 'Smouha Club',
        'isOnline': false,
      };
      final booking = BookingModel.fromJson(bookingJson);
      expect(booking.trainingLocation, 'Smouha Club');
      expect(booking.isOnline, isFalse);

      final map = booking.toMap();
      expect(map['trainingLocation'], 'Smouha Club');
      expect(map['isOnline'], isFalse);

      final onlineBooking = booking.copyWith(
        trainingLocation: 'Online',
        isOnline: true,
      );
      expect(onlineBooking.isOnline, isTrue);
      expect(onlineBooking.trainingLocation, 'Online');
    });
  });
}
