import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'document_upload_helper.dart';

class DocumentUploadCard extends StatefulWidget {
  final String title;
  final String hint;
  final String fileUrl;
  final String folder;
  final ValueChanged<String> onFileUploaded;
  final VoidCallback? onRemove;
  final bool isMandatory;

  const DocumentUploadCard({
    super.key,
    required this.title,
    required this.hint,
    required this.fileUrl,
    required this.onFileUploaded,
    this.folder = 'doc',
    this.onRemove,
    this.isMandatory = true,
  });

  @override
  State<DocumentUploadCard> createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState extends State<DocumentUploadCard> {
  bool _isUploading = false;
  bool _hasError = false;

  Future<void> _handleUpload() async {
    setState(() {
      _isUploading = true;
      _hasError = false;
    });

    try {
      final url = await DocumentUploadHelper.pickAndUploadDocument(
        context: context,
        currentFileUrl: widget.fileUrl,
        folder: widget.folder,
        onRemove: () => widget.onRemove?.call(),
      );
      if (url != null && mounted) {
        widget.onFileUploaded(url);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _handleRemove() async {
    await DocumentUploadHelper.removeFile(widget.fileUrl);
    widget.onRemove?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final isUploaded = widget.fileUrl.isNotEmpty;
    final isPdf = widget.fileUrl.toLowerCase().contains('.pdf');
    final showRemove = widget.onRemove != null &&
        !_isUploading &&
        (isUploaded || !widget.isMandatory);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _hasError
              ? AppColors.error
              : (isUploaded
                  ? AppColors.success
                  : (isDark ? AppColors.darkBorder : AppColors.border)),
          width: isUploaded || _hasError ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _hasError
                    ? Icons.error_outline_rounded
                    : (isUploaded
                        ? (isPdf
                            ? Icons.picture_as_pdf_rounded
                            : Icons.check_circle_rounded)
                        : Icons.description_outlined),
                color: _hasError
                    ? AppColors.error
                    : (isUploaded ? AppColors.success : primary),
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (widget.isMandatory)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    S.of(context).requiredBadge,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            _hasError
                ? S.of(context).uploadFailed
                : (isUploaded
                    ? (isPdf
                        ? S.of(context).pdfUploaded
                        : S.of(context).fileUploaded)
                    : widget.hint),
            style: TextStyle(
              fontSize: 11.sp,
              color: _hasError
                  ? AppColors.error
                  : (isUploaded
                      ? AppColors.success
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary)),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isUploading ? null : _handleUpload,
                  icon: _isUploading
                      ? SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? AppColors.flameRed : primary,
                          ),
                        )
                      : Icon(
                          _hasError
                              ? Icons.refresh_rounded
                              : (isUploaded
                                  ? Icons.cached_rounded
                                  : Icons.upload_file_rounded),
                          size: 16.r,
                        ),
                  label: Text(
                    _isUploading
                        ? S.of(context).uploading
                        : (_hasError
                            ? S.of(context).retry
                            : (isUploaded
                                ? S.of(context).replaceFile
                                : S.of(context).uploadDocument)),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    side: BorderSide(
                      color: _hasError
                          ? AppColors.error
                          : (isUploaded ? AppColors.success : primary),
                    ),
                    foregroundColor: _hasError
                        ? AppColors.error
                        : (isUploaded ? AppColors.success : primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              if (showRemove) ...[
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: _handleRemove,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 20.r,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
