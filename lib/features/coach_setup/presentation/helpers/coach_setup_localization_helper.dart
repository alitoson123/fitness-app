import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

abstract class CoachSetupLocalizationHelper {
  static String getLocalizedSport(BuildContext context, String sport) {
    final s = S.of(context);
    switch (sport.toLowerCase().replaceAll(' ', '_')) {
      case 'gym':
        return s.sportGym;
      case 'football':
        return s.sportFootball;
      case 'boxing':
        return s.sportBoxing;
      case 'swimming':
        return s.sportSwimming;
      case 'basketball':
        return s.sportBasketball;
      case 'tennis':
        return s.sportTennis;
      case 'running':
        return s.sportRunning;
      case 'cycling':
        return s.sportCycling;
      case 'yoga':
        return s.sportYoga;
      case 'martial_arts':
        return s.sportMartialArts;
      case 'volleyball':
        return s.sportVolleyball;
      case 'other':
        return s.sportOther;
      default:
        return sport;
    }
  }

  static String getLocalizedLanguage(BuildContext context, String language) {
    final s = S.of(context);
    switch (language.toLowerCase()) {
      case 'arabic':
        return s.langArabic;
      case 'english':
        return s.langEnglish;
      case 'french':
        return s.langFrench;
      case 'spanish':
        return s.langSpanish;
      case 'german':
        return s.langGerman;
      default:
        return language;
    }
  }

  static String getLocalizedCountry(BuildContext context, String country) {
    final s = S.of(context);
    switch (country) {
      case 'Saudi Arabia':
        return s.countrySaudiArabia;
      case 'United Arab Emirates':
        return s.countryUAE;
      case 'Egypt':
        return s.countryEgypt;
      case 'Kuwait':
        return s.countryKuwait;
      case 'Qatar':
        return s.countryQatar;
      case 'Bahrain':
        return s.countryBahrain;
      case 'Oman':
        return s.countryOman;
      case 'Jordan':
        return s.countryJordan;
      default:
        return country;
    }
  }

  static String getLocalizedValidationError(
    BuildContext context,
    String errorKey,
  ) {
    final s = S.of(context);
    switch (errorKey) {
      case 'photo_required':
        return s.validationPhotoRequired;
      case 'name_required':
        return s.validationNameRequired;
      case 'country_required':
        return s.validationCountryRequired;
      case 'city_required':
        return s.validationCityRequired;
      case 'bio_min_length':
        return s.validationBioMinLength;
      case 'language_required':
        return s.validationLanguageRequired;
      case 'sport_required':
        return s.validationSportRequired;
      case 'rate_required':
        return s.validationRateRequired;
      case 'availability_required':
        return s.validationAvailabilityRequired;
      case 'age_required':
        return s.validationAgeRequired;
      case 'gender_required':
        return s.validationGenderRequired;
      case 'id_required':
        return s.validationIdRequired;
      case 'certRequired':
      case 'cert_required':
        return s.validationCertRequired;
      default:
        return s.validationCheckFields;
    }
  }


}
