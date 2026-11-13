import 'package:fitness_app/features/booking_request/data/repos/booking_actions/booking_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../coach_dashboard/presentation/widgets/booking_status_badge.dart';

class BookingDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final BookingModel booking;

  const BookingDetailsAppBar({super.key, required this.booking});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18.r,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        s.bookingDetailsTitle,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Center(
            child: BookingStatusBadge(
              status: BookingTransitions.displayStatus(booking, DateTime.now()),
            ),
          ),
        ),
      ],
    );
  }
}
