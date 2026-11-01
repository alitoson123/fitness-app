import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_profile_details/presentation/widgets/certificate_preview_dialog.dart';

class CoachProfileCertificatesSection extends StatelessWidget {
  final List<String> certificateUrls;
  final String verificationStatus;

  const CoachProfileCertificatesSection({
    super.key,
    required this.certificateUrls,
    required this.verificationStatus,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final isApproved = verificationStatus == 'approved';

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.workspace_premium_rounded,
                      size: 18.r, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Text(
                    s.certifications,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (isApproved)
                Icon(
                  Icons.verified_rounded,
                  size: 16.r,
                  color: AppColors.success,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.s3),
          if (certificateUrls.isEmpty)
            Text(
              s.noCertificatesUploaded,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.textTertiary,
              ),
            )
          else
            SizedBox(
              height: 72.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: certificateUrls.length,
                separatorBuilder: (_, _) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final url = certificateUrls[index];
                  return _buildThumbnail(context, url);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, String url) {
    return InkWell(
      onTap: () => CertificatePreviewDialog.show(context, url),
      borderRadius: AppRadius.mdAll,
      child: Container(
        width: 72.h,
        height: 72.h,
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.mdAll,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (_, _) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceVariant,
              child: const Icon(
                Icons.description_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
