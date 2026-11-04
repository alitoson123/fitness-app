import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'booking_location_chip.dart';

class BookingLocationSelector extends StatelessWidget {
  final CoachProfileModel coach;
  final String? selectedSport;
  final String? selectedLocation;
  final bool isOnlineTraining;
  final ValueChanged<String> onSelectLocation;
  final VoidCallback onSelectOnline;

  const BookingLocationSelector({
    super.key,
    required this.coach,
    required this.selectedSport,
    required this.selectedLocation,
    required this.isOnlineTraining,
    required this.onSelectLocation,
    required this.onSelectOnline,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedSport == null) return const SizedBox.shrink();

    final config = coach.getLocationConfigForSport(selectedSport!);
    final isOnlineAvailable = config?.isOnline ?? true;
    final locations = config?.locations ?? const <String>[];

    if (!isOnlineAvailable && locations.isEmpty) {
      return const SizedBox.shrink();
    }

    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.place_rounded, size: 16.r, color: primary),
            SizedBox(width: 6.w),
            Text(
              s.chooseTrainingLocation,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            if (isOnlineAvailable)
              BookingLocationChip(
                label: s.onlineTrainingOption,
                icon: Icons.laptop_chromebook_rounded,
                isSelected: isOnlineTraining,
                onTap: onSelectOnline,
                primary: primary,
                isDark: isDark,
                textPrimary: textPrimary,
              ),
            ...locations.map(
              (loc) => BookingLocationChip(
                label: loc,
                icon: Icons.location_on_rounded,
                isSelected: !isOnlineTraining && selectedLocation == loc,
                onTap: () => onSelectLocation(loc),
                primary: primary,
                isDark: isDark,
                textPrimary: textPrimary,
              ),
            ),
          ],
        ),
        if (!isOnlineTraining &&
            (selectedLocation == null || selectedLocation!.isEmpty)) ...[
          SizedBox(height: 6.h),
          Text(
            s.selectDeliveryLocationPrompt,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }
}
