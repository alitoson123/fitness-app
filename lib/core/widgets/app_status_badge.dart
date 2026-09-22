import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

enum AppStatus { pending, approved, rejected, suspended, confirmed, cancelled, active, inactive }

class AppStatusConfig {
  final Color background;
  final Color textColor;
  final Color dotColor;
  final String label;

  const AppStatusConfig({
    required this.background,
    required this.textColor,
    required this.dotColor,
    required this.label,
  });

  static const Map<AppStatus, AppStatusConfig> configs = {
    AppStatus.pending: AppStatusConfig(
      background: Color(0xFFFFFBEB),
      textColor: Color(0xFFD97706),
      dotColor: Color(0xFFD97706),
      label: 'Pending',
    ),
    AppStatus.approved: AppStatusConfig(
      background: Color(0xFFECFDF5),
      textColor: Color(0xFF059669),
      dotColor: Color(0xFF059669),
      label: 'Approved',
    ),
    AppStatus.rejected: AppStatusConfig(
      background: Color(0xFFFEF2F2),
      textColor: Color(0xFFDC2626),
      dotColor: Color(0xFFDC2626),
      label: 'Rejected',
    ),
    AppStatus.suspended: AppStatusConfig(
      background: Color(0xFFF8FAFC),
      textColor: Color(0xFF64748B),
      dotColor: Color(0xFF64748B),
      label: 'Suspended',
    ),
    AppStatus.confirmed: AppStatusConfig(
      background: Color(0xFFEFF6FF),
      textColor: Color(0xFF2563EB),
      dotColor: Color(0xFF2563EB),
      label: 'Confirmed',
    ),
    AppStatus.cancelled: AppStatusConfig(
      background: Color(0xFFFEF2F2),
      textColor: Color(0xFFDC2626),
      dotColor: Color(0xFFDC2626),
      label: 'Cancelled',
    ),
    AppStatus.active: AppStatusConfig(
      background: Color(0xFFECFDF5),
      textColor: Color(0xFF059669),
      dotColor: Color(0xFF059669),
      label: 'Active',
    ),
    AppStatus.inactive: AppStatusConfig(
      background: Color(0xFFF8FAFC),
      textColor: Color(0xFF94A3B8),
      dotColor: Color(0xFF94A3B8),
      label: 'Inactive',
    ),
  };

  static AppStatusConfig get(AppStatus status) => configs[status]!;
}

class AppStatusBadge extends StatelessWidget {
  final AppStatus status;
  final String? customLabel;

  const AppStatusBadge({super.key, required this.status, this.customLabel});

  @override
  Widget build(BuildContext context) {
    final config = AppStatusConfig.get(status);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? config.dotColor.withValues(alpha: 0.18) : config.background;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: config.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSpacing.s1),
          Text(
            customLabel ?? config.label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
