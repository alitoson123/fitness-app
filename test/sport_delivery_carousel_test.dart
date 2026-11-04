import 'package:fitness_app/core/helpers/sport_icon_helper.dart';
import 'package:fitness_app/core/widgets/app_page_indicator.dart';
import 'package:fitness_app/core/widgets/sport_carousel_card.dart';
import 'package:fitness_app/core/widgets/sport_delivery_carousel.dart';
import 'package:fitness_app/features/coach_setup/data/models/sport_location_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestable(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('SportIconHelper Tests', () {
    test('returns correct icons for sports', () {
      expect(SportIconHelper.getIcon('basketball'), Icons.sports_basketball_rounded);
      expect(SportIconHelper.getIcon('swimming'), Icons.pool_rounded);
      expect(SportIconHelper.getIcon('gym'), Icons.fitness_center_rounded);
      expect(SportIconHelper.getIcon('football'), Icons.sports_soccer_rounded);
      expect(SportIconHelper.getIcon('boxing'), Icons.sports_mma_rounded);
      expect(SportIconHelper.getIcon('tennis'), Icons.sports_tennis_rounded);
      expect(SportIconHelper.getIcon('yoga'), Icons.self_improvement_rounded);
      expect(SportIconHelper.getIcon('unknown_sport'), Icons.sports_rounded);
    });
  });

  group('SportDeliveryCarousel Widget Tests (Option 3)', () {
    testWidgets('renders SizedBox.shrink when sports list is empty', (tester) async {
      await tester.pumpWidget(
        _buildTestable(
          const SportDeliveryCarousel(
            sports: [],
            isDark: true,
            primary: Colors.orange,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SportCarouselCard), findsNothing);
      expect(find.byType(PageView), findsNothing);
    });

    testWidgets('renders single card without PageView or dots for 1 sport', (tester) async {
      final config = SportLocationModel(
        sport: 'basketball',
        isOnline: true,
        locations: const ['Hulk Gym'],
      );

      await tester.pumpWidget(
        _buildTestable(
          SportDeliveryCarousel(
            sports: const ['basketball'],
            sportLocations: [config],
            isDark: true,
            primary: Colors.orange,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SportCarouselCard), findsOneWidget);
      expect(find.byType(PageView), findsNothing);
      expect(find.byType(AppPageIndicator), findsNothing);
      expect(find.text('Hulk Gym'), findsOneWidget);
    });

    testWidgets('renders PageView and AppPageIndicator for multiple sports', (tester) async {
      final configs = [
        SportLocationModel(
          sport: 'basketball',
          isOnline: true,
          locations: const ['Hulk Gym', 'Men Gym'],
        ),
        SportLocationModel(
          sport: 'swimming',
          isOnline: false,
          locations: const ['Ali Gym'],
        ),
      ];

      await tester.pumpWidget(
        _buildTestable(
          SportDeliveryCarousel(
            sports: const ['basketball', 'swimming'],
            sportLocations: configs,
            isDark: true,
            primary: Colors.orange,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(AppPageIndicator), findsOneWidget);
      expect(find.text('Hulk Gym'), findsOneWidget);
    });
  });
}

