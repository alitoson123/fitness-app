import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class CertificatePreviewDialog extends StatelessWidget {
  final String imageUrl;

  const CertificatePreviewDialog({super.key, required this.imageUrl});

  static void show(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => CertificatePreviewDialog(imageUrl: imageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      insetPadding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).viewCertificate,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  splashRadius: 20.r,
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 400.h),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, _) => SizedBox(
                  height: 200.h,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, _, _) => SizedBox(
                  height: 150.h,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 48.r,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
