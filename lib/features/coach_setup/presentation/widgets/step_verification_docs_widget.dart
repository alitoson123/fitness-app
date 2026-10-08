import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';
import 'add_supporting_document_button.dart';
import 'document_upload_card.dart';

class StepVerificationDocsWidget extends StatelessWidget {
  final CoachSetupCubit cubit;

  const StepVerificationDocsWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).verificationDocsTitle,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).verificationDocsSubtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          DocumentUploadCard(
            title: S.of(context).nationalIdOrPassport,
            hint: S.of(context).nationalIdHint,
            fileUrl: cubit.identityDocumentUrl,
            folder: 'identity_doc',
            isMandatory: true,
            onFileUploaded: cubit.setIdentityDocument,
            onRemove: () => cubit.setIdentityDocument(''),
          ),
          SizedBox(height: 14.h),
          DocumentUploadCard(
            title: S.of(context).coachingCertificates,
            hint: S.of(context).coachingCertificatesHint,
            fileUrl: cubit.certificateUrls.isNotEmpty
                ? cubit.certificateUrls.first
                : '',
            folder: 'certificate_primary',
            isMandatory: true,
            onFileUploaded: (url) {
              if (cubit.certificateUrls.isEmpty) {
                cubit.addCertificate(url);
              } else {
                cubit.updateCertificate(0, url);
              }
            },
            onRemove: () {
              if (cubit.certificateUrls.length > 1) {
                cubit.updateCertificate(0, '');
              } else {
                cubit.removeCertificate(0);
              }
            },
          ),
          if (cubit.certificateUrls.length > 1) ...[
            SizedBox(height: 14.h),
            ...cubit.certificateUrls.asMap().entries.skip(1).map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: DocumentUploadCard(
                  title: S.of(context).additionalCertificate(entry.key),
                  hint: S.of(context).additionalCertificateHint,
                  fileUrl: entry.value,
                  folder: 'certificate_supporting_${entry.key}',
                  isMandatory: false,
                  onFileUploaded: (url) =>
                      cubit.updateCertificate(entry.key, url),
                  onRemove: () => cubit.removeCertificate(entry.key),
                ),
              );
            }),
          ],
          SizedBox(height: 14.h),
          AddSupportingDocumentButton(
            onTap: () {
              if (cubit.certificateUrls.isEmpty) {
                cubit.addCertificate('');
                cubit.addCertificate('');
              } else {
                cubit.addCertificate('');
              }
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
