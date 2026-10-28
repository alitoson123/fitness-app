import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_parser_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoachProfileModel Dual Pricing & USD Tests', () {
    test('default model has USD currency and 0.0 dual prices', () {
      const model = CoachProfileModel(uid: 'coach-123');
      expect(model.currency, equals('USD'));
      expect(model.sessionPriceUSD, equals(0.0));
      expect(model.monthlyPriceUSD, equals(0.0));
      expect(model.sessionPrice, equals(0.0));
      expect(model.hourlyRate, equals(0.0));
    });

    test('constructor maps sessionPrice to sessionPriceUSD for backward compat', () {
      const model = CoachProfileModel(
        uid: 'coach-123',
        sessionPrice: 45.0,
        monthlyPriceUSD: 180.0,
      );
      expect(model.sessionPriceUSD, equals(45.0));
      expect(model.sessionPrice, equals(45.0));
      expect(model.monthlyPriceUSD, equals(180.0));
      expect(model.currency, equals('USD'));
    });

    test('fromJson parses sessionPriceUSD, monthlyPriceUSD and enforces USD currency', () {
      final json = {
        'uid': 'coach-456',
        'name': 'Coach Sam',
        'sessionPriceUSD': 60.0,
        'monthlyPriceUSD': 250.0,
        'currency': 'SAR', // Should be overridden to strict USD
      };

      final model = CoachProfileModel.fromJson(json);
      expect(model.uid, equals('coach-456'));
      expect(model.sessionPriceUSD, equals(60.0));
      expect(model.monthlyPriceUSD, equals(250.0));
      expect(model.currency, equals('USD'));
    });

    test('fromJson falls back to legacy hourlyRate and sessionPrice keys', () {
      final jsonWithHourlyRate = {
        'uid': 'coach-789',
        'hourlyRate': 75.0,
      };
      final model = CoachProfileModel.fromJson(jsonWithHourlyRate);
      expect(model.sessionPriceUSD, equals(75.0));
      expect(model.monthlyPriceUSD, equals(0.0));
      expect(model.currency, equals('USD'));
    });

    test('toMap writes sessionPriceUSD, monthlyPriceUSD, hourlyRate and USD', () {
      const model = CoachProfileModel(
        uid: 'coach-123',
        sessionPriceUSD: 55.0,
        monthlyPriceUSD: 220.0,
      );

      final map = model.toMap();
      expect(map['sessionPriceUSD'], equals(55.0));
      expect(map['monthlyPriceUSD'], equals(220.0));
      expect(map['hourlyRate'], equals(55.0));
      expect(map['currency'], equals('USD'));
    });
  });

  group('CoachProfileParserHelper Pricing Tests', () {
    test('parsePrice correctly converts num, string and handles null/invalid', () {
      expect(CoachProfileParserHelper.parsePrice(50), equals(50.0));
      expect(CoachProfileParserHelper.parsePrice(50.5), equals(50.5));
      expect(CoachProfileParserHelper.parsePrice('120'), equals(120.0));
      expect(CoachProfileParserHelper.parsePrice('120.75'), equals(120.75));
      expect(CoachProfileParserHelper.parsePrice(null), equals(0.0));
      expect(CoachProfileParserHelper.parsePrice('invalid'), equals(0.0));
    });

    test('isValidPrice checks positive price (> 0)', () {
      expect(CoachProfileParserHelper.isValidPrice(10.0), isTrue);
      expect(CoachProfileParserHelper.isValidPrice(0.1), isTrue);
      expect(CoachProfileParserHelper.isValidPrice(0.0), isFalse);
      expect(CoachProfileParserHelper.isValidPrice(-5.0), isFalse);
      expect(CoachProfileParserHelper.isValidPrice(null), isFalse);
    });
  });
}

