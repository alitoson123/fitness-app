import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

enum AppAvatarSize { sm, md, lg, xl }

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AppAvatarSize size;
  final bool editable;
  final VoidCallback? onEdit;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppAvatarSize.md,
    this.editable = false,
    this.onEdit,
  });

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    return parts.take(2).map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();
  }

  (double diameter, double fontSize) _getSizeSpecs() {
    switch (size) {
      case AppAvatarSize.sm:
        return (32.r, 11.sp);
      case AppAvatarSize.md:
        return (40.r, 13.sp);
      case AppAvatarSize.lg:
        return (56.r, 18.sp);
      case AppAvatarSize.xl:
        return (80.r, 26.sp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (diameter, fontSize) = _getSizeSpecs();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: diameter,
          height: diameter,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: AppColors.avatarGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: diameter,
                  height: diameter,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      _initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    _initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
        ),
        if (editable)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2.w,
                  ),
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 12.r),
              ),
            ),
          ),
      ],
    );
  }
}
