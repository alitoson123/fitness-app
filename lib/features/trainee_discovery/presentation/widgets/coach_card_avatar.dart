import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CoachCardAvatar extends StatelessWidget {
  final String photoUrl;
  final String name;

  const CoachCardAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
  });

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'C';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _getInitials(name);

    if (photoUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: photoUrl,
        imageBuilder: (context, imageProvider) => Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.darkSurfaceVariant
                : AppColors.surfaceVariant,
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallback(isDark, initials),
      );
    }

    return _buildFallback(isDark, initials);
  }

  Widget _buildFallback(bool isDark, String initials) {
    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
