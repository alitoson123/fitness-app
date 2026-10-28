import '../../../../core/models/day_availability.dart';
import 'coach_profile_serializer.dart';

class CoachProfileModel {
  final String uid, name, phoneNumber, photoUrl, bio, country, city, gender;
  final int age, yearsOfExperience, sessionDurationMinutes, reviewsCount;
  final double sessionPriceUSD, monthlyPriceUSD, rating;
  final String currency, availabilitySummary, verificationStatus;
  final List<String> languages, sports, specialties, workingDays, certificateUrls;
  final Map<String, dynamic>? workingHours;
  final List<DayAvailability> weeklyAvailability;
  final DateTime? updatedAt;

  double get sessionPrice => sessionPriceUSD;
  double get hourlyRate => sessionPriceUSD;

  const CoachProfileModel({
    required this.uid,
    this.name = '',
    this.phoneNumber = '',
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
    double? sessionPrice,
    double? sessionPriceUSD,
    this.monthlyPriceUSD = 0.0,
    this.currency = 'USD',
    this.availabilitySummary = '',
    this.sessionDurationMinutes = 60,
    this.workingDays = const [],
    this.workingHours,
    this.weeklyAvailability = const [],
    this.certificateUrls = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.verificationStatus = 'pending',
    this.updatedAt,
  }) : sessionPriceUSD = sessionPriceUSD ?? sessionPrice ?? 0.0;

  factory CoachProfileModel.fromJson(
    Map<String, dynamic> json, {
    String? uid,
  }) =>
      CoachProfileSerializer.fromJson(json, uid: uid);

  Map<String, dynamic> toMap() => CoachProfileSerializer.toMap(this);

  CoachProfileModel copyWith({
    String? uid,
    String? name,
    String? phoneNumber,
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
    double? sessionPrice,
    double? sessionPriceUSD,
    double? monthlyPriceUSD,
    String? currency,
    String? availabilitySummary,
    int? sessionDurationMinutes,
    List<String>? workingDays,
    Map<String, dynamic>? workingHours,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
      sessionPriceUSD: sessionPriceUSD ?? sessionPrice ?? this.sessionPriceUSD,
      monthlyPriceUSD: monthlyPriceUSD ?? this.monthlyPriceUSD,
      currency: currency ?? this.currency,
      availabilitySummary: availabilitySummary ?? this.availabilitySummary,
      sessionDurationMinutes:
          sessionDurationMinutes ?? this.sessionDurationMinutes,
      workingDays: workingDays ?? this.workingDays,
      workingHours: workingHours ?? this.workingHours,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
      certificateUrls: certificateUrls ?? this.certificateUrls,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
