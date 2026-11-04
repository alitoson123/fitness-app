import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/coach_setup/data/models/sport_location_model.dart';
import 'app_page_indicator.dart';
import 'sport_carousel_card.dart';

class SportDeliveryCarousel extends StatefulWidget {
  final List<String> sports;
  final List<SportLocationModel> sportLocations;
  final bool isDark;
  final Color primary;
  final EdgeInsetsGeometry? margin;

  const SportDeliveryCarousel({
    super.key,
    required this.sports,
    this.sportLocations = const [],
    required this.isDark,
    required this.primary,
    this.margin,
  });

  @override
  State<SportDeliveryCarousel> createState() => _SportDeliveryCarouselState();
}

class _SportDeliveryCarouselState extends State<SportDeliveryCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.sports.length > 1 ? 0.88 : 1.0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  SportLocationModel? _getConfig(String sport) {
    final target = sport.toLowerCase().replaceAll(' ', '_').trim();
    return widget.sportLocations.cast<SportLocationModel?>().firstWhere(
          (l) => l?.sport.toLowerCase().replaceAll(' ', '_').trim() == target,
          orElse: () => null,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sports.isEmpty) return const SizedBox.shrink();

    final outerMargin = widget.margin ?? EdgeInsets.symmetric(horizontal: 16.w);

    if (widget.sports.length == 1) {
      final sport = widget.sports.first;
      return Container(
        margin: outerMargin,
        child: SportCarouselCard(
          sport: sport,
          config: _getConfig(sport),
          isDark: widget.isDark,
          primary: widget.primary,
        ),
      );
    }

    return Container(
      margin: outerMargin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 136.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.sports.length,
              padEnds: false,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                final sport = widget.sports[index];
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 10.w),
                  child: SportCarouselCard(
                    sport: sport,
                    config: _getConfig(sport),
                    isDark: widget.isDark,
                    primary: widget.primary,
                    hasFixedHeight: true,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          AppPageIndicator(
            total: widget.sports.length,
            current: _currentIndex.clamp(0, widget.sports.length - 1),
          ),
        ],
      ),
    );
  }
}
