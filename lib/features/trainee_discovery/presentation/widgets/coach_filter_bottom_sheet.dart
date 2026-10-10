import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/discovery_filter_model.dart';
import '../../data/models/discovery_sort_option.dart';
import 'filter_bottom_sheet_header.dart';
import 'filter_experience_selector.dart';
import 'filter_gender_selector.dart';
import 'filter_price_slider.dart';
import 'filter_rating_selector.dart';
import 'filter_sort_selector.dart';

class CoachFilterBottomSheet extends StatefulWidget {
  final DiscoveryFilterModel initialFilter;
  final ValueChanged<DiscoveryFilterModel> onApply;

  const CoachFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required DiscoveryFilterModel initialFilter,
    required ValueChanged<DiscoveryFilterModel> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CoachFilterBottomSheet(
        initialFilter: initialFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<CoachFilterBottomSheet> createState() => _CoachFilterBottomSheetState();
}

class _CoachFilterBottomSheetState extends State<CoachFilterBottomSheet> {
  late RangeValues _priceRange;
  late int _minExperience;
  late String _gender;
  late double _minRating;
  late DiscoverySortOption _sortOption;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilter;
    _priceRange = RangeValues(f.minPrice, f.maxPrice);
    _minExperience = f.minExperience;
    _gender = f.gender;
    _minRating = f.minRating;
    _sortOption = f.sortOption;
  }

  void _reset() {
    setState(() {
      _priceRange = const RangeValues(0.0, 1000.0);
      _minExperience = 0;
      _gender = 'all';
      _minRating = 0.0;
      _sortOption = DiscoverySortOption.recommended;
    });
  }

  void _apply() {
    final updated = widget.initialFilter.copyWith(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      minExperience: _minExperience,
      gender: _gender,
      minRating: _minRating,
      sortOption: _sortOption,
    );
    widget.onApply(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : Colors.white;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.88.sh),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            FilterBottomSheetHeader(
              onReset: _reset,
              onClose: () => Navigator.of(context).pop(),
              primaryColor: primary,
              textPrimaryColor: textPrimary,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                children: [
                  FilterPriceSlider(
                    range: _priceRange,
                    onChanged: (val) => setState(() => _priceRange = val),
                  ),
                  SizedBox(height: 18.h),
                  FilterSortSelector(
                    selectedSort: _sortOption,
                    onChanged: (val) => setState(() => _sortOption = val),
                  ),
                  SizedBox(height: 18.h),
                  FilterGenderSelector(
                    selectedGender: _gender,
                    onChanged: (val) => setState(() => _gender = val),
                  ),
                  SizedBox(height: 18.h),
                  FilterExperienceSelector(
                    selectedExperience: _minExperience,
                    onChanged: (val) => setState(() => _minExperience = val),
                  ),
                  SizedBox(height: 18.h),
                  FilterRatingSelector(
                    selectedRating: _minRating,
                    onChanged: (val) => setState(() => _minRating = val),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
              child: AppButton(
                label: S.of(context).applyFilters,
                onPressed: _apply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
