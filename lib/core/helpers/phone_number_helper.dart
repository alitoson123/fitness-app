enum SupportedCountry {
  egypt(
    countryCode: '+20',
    isoCode: 'EG',
    flag: '🇪🇬',
    nameEn: 'Egypt',
    nameAr: 'مصر',
    hintText: '10 1234 5678',
    maxLength: 10,
  ),
  lebanon(
    countryCode: '+961',
    isoCode: 'LB',
    flag: '🇱🇧',
    nameEn: 'Lebanon',
    nameAr: 'لبنان',
    hintText: '70 123 456',
    maxLength: 8,
  );

  final String countryCode;
  final String isoCode;
  final String flag;
  final String nameEn;
  final String nameAr;
  final String hintText;
  final int maxLength;

  const SupportedCountry({
    required this.countryCode,
    required this.isoCode,
    required this.flag,
    required this.nameEn,
    required this.nameAr,
    required this.hintText,
    required this.maxLength,
  });

  String localizedName(bool isArabic) => isArabic ? nameAr : nameEn;
}

class PhoneNumberHelper {
  /// Strips whitespace, dashes, and any leading zero.
  static String sanitizePhoneNumber(String rawNumber) {
    String cleaned = rawNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
    return cleaned;
  }

  /// Validates national number against country-specific carrier prefixes.
  static bool isValidNumber({
    required SupportedCountry country,
    required String rawNumber,
  }) {
    final clean = sanitizePhoneNumber(rawNumber);
    switch (country) {
      case SupportedCountry.egypt:
        final regExp = RegExp(r'^(10|11|12|15)[0-9]{8}$');
        return regExp.hasMatch(clean);
      case SupportedCountry.lebanon:
        final regExp = RegExp(r'^(3[0-9]{6}|(70|71|76|78|79|81|86)[0-9]{6})$');
        return regExp.hasMatch(clean);
    }
  }

  /// Builds full E.164 format (e.g. "+201012345678").
  static String formatToE164({
    required SupportedCountry country,
    required String rawNumber,
  }) {
    final clean = sanitizePhoneNumber(rawNumber);
    return '${country.countryCode}$clean';
  }

  /// Formats phone number for readable display with mask for OTP screen.
  static String maskPhoneNumber({
    required SupportedCountry country,
    required String rawNumber,
  }) {
    final clean = sanitizePhoneNumber(rawNumber);
    if (clean.length < 5) {
      return '${country.countryCode} $clean';
    }
    final start = clean.substring(0, 2);
    final end = clean.substring(clean.length - 2);
    return '${country.countryCode} $start **** $end';
  }
}
