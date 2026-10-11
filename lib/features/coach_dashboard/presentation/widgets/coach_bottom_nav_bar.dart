import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class CoachBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final int pendingCount;
  final ValueChanged<int> onTap;

  const CoachBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.pendingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          top: BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.flameRed,
          unselectedItemColor: AppColors.darkTextTertiary,
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard_rounded),
              label: s.coachNavDashboard,
            ),
            BottomNavigationBarItem(
              icon: _buildBadgeIcon(
                icon: Icons.calendar_month_outlined,
              ),
              activeIcon: _buildBadgeIcon(
                icon: Icons.calendar_month_rounded,
              ),
              label: s.coachNavBookings,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.schedule_outlined),
              activeIcon: const Icon(Icons.schedule_rounded),
              label: s.coachNavAvailability,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon({required IconData icon}) {
    return Badge(
      isLabelVisible: pendingCount > 0,
      label: Text(
        '$pendingCount',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.flameRed,
      child: Icon(icon),
    );
  }
}
