import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoachProfileModel.toFirestoreMap', () {
    const profile = CoachProfileModel(
      uid: 'coach_1',
      name: 'Sara',
      verificationStatus: 'pending',
      rating: 4.5,
      reviewsCount: 12,
    );

    test('omits admin-controlled fields so a stale cache cannot overwrite them',
        () {
      final map = profile.toFirestoreMap();

      expect(map.containsKey('verificationStatus'), isFalse);
      expect(map.containsKey('rating'), isFalse);
      expect(map.containsKey('reviewsCount'), isFalse);
      expect(map['uid'], 'coach_1');
      expect(map['name'], 'Sara');
    });

    test('toMap still keeps them for the local cache', () {
      final map = profile.toMap();

      expect(map['verificationStatus'], 'pending');
      expect(map['rating'], 4.5);
      expect(map['reviewsCount'], 12);
    });
  });
}
