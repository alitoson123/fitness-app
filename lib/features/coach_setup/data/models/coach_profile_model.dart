import 'package:cloud_firestore/cloud_firestore.dart';

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
  final double rating;
  final int reviewsCount;
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
    this.rating = 0.0,
    this.reviewsCount = 0,
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
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      sports: (json['sports'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      sessionPrice: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'SAR',
      availabilitySummary: json['availabilitySummary'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
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
      'rating': rating,
      'reviewsCount': reviewsCount,
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
    double? rating,
    int? reviewsCount,
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
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
