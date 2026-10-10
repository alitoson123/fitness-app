import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'certificate_preview_dialog.dart';
import 'coach_info_tile.dart';

class CoachCredentialsSection extends StatelessWidget {
  final CoachProfileModel coach;

  const CoachCredentialsSection({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      width: double.infinity,
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
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                size: 20.r,
                color: primary,
              ),
              SizedBox(width: 8.w),
              Text(
                S.of(context).credentialsAndQualifications,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(context, isDark, textPrimary, textSecondary),
          SizedBox(height: 14.h),
          _buildCertificates(context, isDark, primary, textSecondary),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    final s = S.of(context);
    final languagesText = coach.languages.isNotEmpty
        ? coach.languages.join(', ')
        : 'Arabic, English';

    return Row(
      children: [
        Expanded(
          child: CoachInfoTile(
            icon: Icons.timeline_rounded,
            title: s.minExperienceYears,
            value: s.experienceYearsCount(coach.yearsOfExperience),
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CoachInfoTile(
            icon: Icons.translate_rounded,
            title: s.spokenLanguages,
            value: languagesText,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificates(
    BuildContext context,
    bool isDark,
    Color primary,
    Color textSecondary,
  ) {
    if (coach.certificateUrls.isEmpty) {
      return Row(
        children: [
          Icon(Icons.verified_user_outlined, size: 16.r, color: AppColors.success),
          SizedBox(width: 6.w),
          Text(
            S.of(context).verifiedCertifications,
            style: TextStyle(fontSize: 12.sp, color: textSecondary),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).certifications,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 64.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: coach.certificateUrls.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final url = coach.certificateUrls[index];
              return GestureDetector(
                onTap: () => CertificatePreviewDialog.show(context, url),
                child: ClipRRect(
                  borderRadius: AppRadius.smAll,
                  child: Container(
                    width: 64.w,
                    height: 64.h,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (_, _, _) =>
                          const Icon(Icons.document_scanner_rounded),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
