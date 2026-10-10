import '../../../../core/models/day_availability.dart';
import 'coach_profile_parser_helper.dart';

class CoachProfileModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String bio;
  final String country;
  final String city;
  final int age;
  final String gender;
  final List<String> languages;
  final List<String> sports;
  final List<String> specialties;
  final int yearsOfExperience;
  final double sessionPrice;
  final String currency;
  final String availabilitySummary;
  final List<DayAvailability> weeklyAvailability;
  final List<String> certificateUrls;
  final double rating;
  final int reviewsCount;
  final String verificationStatus;
  final DateTime? updatedAt;

  const CoachProfileModel({
    required this.uid,
    this.name = '',
    this.email = '',
    this.photoUrl = '',
    this.bio = '',
    this.country = '',
    this.city = '',
    this.age = 0,
    this.gender = 'male',
    this.languages = const [],
    this.sports = const [],
    this.specialties = const [],
    this.yearsOfExperience = 0,
    this.sessionPrice = 0.0,
    this.currency = 'SAR',
    this.availabilitySummary = '',
    this.weeklyAvailability = const [],
    this.certificateUrls = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.verificationStatus = 'pending',
    this.updatedAt,
  });

  factory CoachProfileModel.fromJson(Map<String, dynamic> json, {String? uid}) {
    return CoachProfileModel(
      uid: uid ?? json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? 'male',
      languages: CoachProfileParserHelper.parseList(json['languages']),
      sports: CoachProfileParserHelper.parseList(json['sports']),
      specialties: CoachProfileParserHelper.parseList(json['specialties']),
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      sessionPrice: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'SAR',
      availabilitySummary: json['availabilitySummary'] as String? ?? '',
      weeklyAvailability: CoachProfileParserHelper.parseAvailability(
        json['weeklyAvailability'],
      ),
      certificateUrls: CoachProfileParserHelper.parseList(
        json['certificateUrls'],
      ),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      verificationStatus: json['verificationStatus'] as String? ?? 'pending',
      updatedAt: CoachProfileParserHelper.parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      if (email.isNotEmpty) 'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'country': country,
      'city': city,
      'age': age,
      'gender': gender,
      'languages': languages,
      'sports': sports,
      'specialties': specialties,
      'yearsOfExperience': yearsOfExperience,
      'hourlyRate': sessionPrice,
      'currency': currency,
      'availabilitySummary': availabilitySummary,
      if (weeklyAvailability.isNotEmpty)
        'weeklyAvailability': weeklyAvailability.map((e) => e.toMap()).toList(),
      if (certificateUrls.isNotEmpty) 'certificateUrls': certificateUrls,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'verificationStatus': verificationStatus,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  CoachProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    String? country,
    String? city,
    int? age,
    String? gender,
    List<String>? languages,
    List<String>? sports,
    List<String>? specialties,
    int? yearsOfExperience,
    double? hourlyRate,
    String? currency,
    String? availabilitySummary,
    List<DayAvailability>? weeklyAvailability,
    List<String>? certificateUrls,
    double? rating,
    int? reviewsCount,
    String? verificationStatus,
    DateTime? updatedAt,
  }) {
    return CoachProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      country: country ?? this.country,
      city: city ?? this.city,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      languages: languages ?? this.languages,
      sports: sports ?? this.sports,
      specialties: specialties ?? this.specialties,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      sessionPrice: hourlyRate ?? sessionPrice,
      currency: currency ?? this.currency,
      availabilitySummary: availabilitySummary ?? this.availabilitySummary,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
      certificateUrls: certificateUrls ?? this.certificateUrls,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
