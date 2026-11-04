import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/sport_location_model.dart';
import '../helpers/coach_setup_localization_helper.dart';
import 'sport_location_input_row.dart';
import 'sport_location_venue_chip.dart';

class SportLocationConfigCard extends StatefulWidget {
  final SportLocationModel config;
  final ValueChanged<bool> onToggleOnline;
  final ValueChanged<String> onAddLocation;
  final ValueChanged<int> onRemoveLocation;
  final bool isDark;
  final Color primary;

  const SportLocationConfigCard({
    super.key,
    required this.config,
    required this.onToggleOnline,
    required this.onAddLocation,
    required this.onRemoveLocation,
    required this.isDark,
    required this.primary,
  });

  @override
  State<SportLocationConfigCard> createState() => _SportLocationConfigCardState();
}

class _SportLocationConfigCardState extends State<SportLocationConfigCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onAddLocation(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cardBg = widget.isDark ? AppColors.darkSurface : Colors.white;
    final border = widget.isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = widget.isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = widget.isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final sportName = CoachSetupLocalizationHelper.getLocalizedSport(context, widget.config.sport);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: widget.config.isValid ? border : AppColors.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports_rounded, size: 18.r, color: widget.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(sportName, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: textPrimary)),
              ),
              if (widget.config.isValid)
                Icon(Icons.check_circle_rounded, size: 16.r, color: AppColors.success),
            ],
          ),
          Divider(height: 20.h, color: border),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: widget.config.isOnline,
            onChanged: widget.onToggleOnline,
            activeThumbColor: widget.primary,
            title: Text(s.availableForOnlineTraining, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: textPrimary)),
            subtitle: Text(s.availableForOnlineTrainingSubtitle, style: TextStyle(fontSize: 11.sp, color: textSecondary)),
          ),
          SizedBox(height: 8.h),
          Text(s.physicalLocations, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textPrimary)),
          SizedBox(height: 6.h),
          if (widget.config.locations.isNotEmpty)
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: List.generate(widget.config.locations.length, (i) {
                return SportLocationVenueChip(
                  location: widget.config.locations[i],
                  onRemove: () => widget.onRemoveLocation(i),
                  isDark: widget.isDark,
                );
              }),
            ),
          SizedBox(height: 8.h),
          SportLocationInputRow(controller: _controller, onAdd: _handleAdd, primary: widget.primary),
          if (!widget.config.isValid) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: AppRadius.smAll,
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 14.r, color: AppColors.warning),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(s.noLocationsOrOnlineWarning, style: TextStyle(fontSize: 11.sp, color: AppColors.warning)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
