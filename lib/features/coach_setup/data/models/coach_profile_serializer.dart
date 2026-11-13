import 'coach_profile_model.dart';
import 'coach_profile_parser_helper.dart';

class CoachProfileSerializer {
  static CoachProfileModel fromJson(
    Map<String, dynamic> json, {
    String? uid,
  }) {
    return CoachProfileModel(
      uid: uid ?? json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber:
          json['phoneNumber'] as String? ?? json['number'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? 'male',
      languages: CoachProfileParserHelper.parseList(json['languages']),
      sports: CoachProfileParserHelper.parseList(json['sports']),
      specialties: CoachProfileParserHelper.parseList(json['specialties']),
      sportLocations: CoachProfileParserHelper.parseSportLocations(
        json['sportLocations'],
        CoachProfileParserHelper.parseList(json['sports']),
      ),
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      sessionPriceUSD: CoachProfileParserHelper.parsePrice(
        json['sessionPriceUSD'],
      ),
      monthlyPriceUSD: CoachProfileParserHelper.parsePrice(
        json['monthlyPriceUSD'],
      ),
      currency: 'USD',
      availabilitySummary: json['availabilitySummary'] as String? ?? '',
      sessionDurationMinutes: json['sessionDurationMinutes'] as int? ?? 60,
      workingDays: CoachProfileParserHelper.parseList(json['workingDays']),
      workingHours: CoachProfileParserHelper.parseMap(json['workingHours']),
      weeklyAvailability: CoachProfileParserHelper.parseAvailability(
        json['weeklyAvailability'],
      ),
      certificateUrls:
          CoachProfileParserHelper.parseList(json['certificateUrls']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      verificationStatus: json['verificationStatus'] as String? ?? 'pending',
      updatedAt: CoachProfileParserHelper.parseDateTime(json['updatedAt']),
    );
  }

  static Map<String, dynamic> toMap(CoachProfileModel m) => {
        'uid': m.uid,
        'name': m.name,
        if (m.phoneNumber.isNotEmpty) 'phoneNumber': m.phoneNumber,
        'photoUrl': m.photoUrl,
        'bio': m.bio,
        'country': m.country,
        'city': m.city,
        'age': m.age,
        'gender': m.gender,
        'languages': m.languages,
        'sports': m.sports,
        'specialties': m.specialties,
        if (m.sportLocations.isNotEmpty)
          'sportLocations': m.sportLocations.map((e) => e.toMap()).toList(),
        'yearsOfExperience': m.yearsOfExperience,
        'sessionPriceUSD': m.sessionPriceUSD,
        'monthlyPriceUSD': m.monthlyPriceUSD,
        'currency': 'USD',
        'availabilitySummary': m.availabilitySummary,
        'sessionDurationMinutes': m.sessionDurationMinutes,
        'workingDays': m.workingDays.isNotEmpty
            ? m.workingDays
            : m.weeklyAvailability
                .where((e) => e.isAvailable)
                .map((e) => e.day.name)
                .toList(),
        if (m.workingHours != null) 'workingHours': m.workingHours,
        if (m.weeklyAvailability.isNotEmpty)
          'weeklyAvailability':
              m.weeklyAvailability.map((e) => e.toMap()).toList(),
        if (m.certificateUrls.isNotEmpty)
          'certificateUrls': m.certificateUrls,
        'rating': m.rating,
        'reviewsCount': m.reviewsCount,
        'verificationStatus': m.verificationStatus,
        if (m.updatedAt != null) 'updatedAt': m.updatedAt!.toIso8601String(),
      };

  /// Fields controlled by the admin dashboard, never written by the coach app.
  static const adminControlledKeys = {
    'verificationStatus',
    'rating',
    'reviewsCount',
  };

  /// Payload for coach-initiated Firestore writes. Omits admin-controlled
  /// fields so a stale local copy can never overwrite the admin's values
  /// (and so the writes satisfy the `coach_profiles` security rules).
  static Map<String, dynamic> toFirestoreMap(CoachProfileModel m) =>
      Map.of(toMap(m))
        ..removeWhere((key, _) => adminControlledKeys.contains(key));
}

