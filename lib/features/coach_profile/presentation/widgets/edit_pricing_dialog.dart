import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

class EditPricingDialog extends StatefulWidget {
  final CoachProfileModel profile;
  final void Function(double sessionPriceUSD, double monthlyPriceUSD) onSave;

  const EditPricingDialog({
    super.key,
    required this.profile,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required CoachProfileModel profile,
    required void Function(double sessionPriceUSD, double monthlyPriceUSD)
        onSave,
  }) {
    return showDialog(
      context: context,
      builder: (_) => EditPricingDialog(profile: profile, onSave: onSave),
    );
  }

  @override
  State<EditPricingDialog> createState() => _EditPricingDialogState();
}

class _EditPricingDialogState extends State<EditPricingDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _sessionController;
  late final TextEditingController _monthlyController;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _sessionController = TextEditingController(
      text: p.sessionPriceUSD > 0 ? p.sessionPriceUSD.toStringAsFixed(0) : '',
    );
    _monthlyController = TextEditingController(
      text: p.monthlyPriceUSD > 0 ? p.monthlyPriceUSD.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _sessionController.dispose();
    _monthlyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final sessionPrice = double.tryParse(_sessionController.text.trim()) ?? 0.0;
    final monthlyPrice = double.tryParse(_monthlyController.text.trim()) ?? 0.0;
    widget.onSave(sessionPrice, monthlyPrice);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      insetPadding: EdgeInsets.all(20.r),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                s.quickEditPricingTitle,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.s4),
              AppTextField(
                controller: _sessionController,
                label: s.singleSessionPriceUSD,
                hint: s.singleSessionPriceUSDHint,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: const Icon(Icons.attach_money_rounded),
                validator: (val) {
                  final n = double.tryParse(val ?? '');
                  return (n == null || n <= 0)
                      ? s.validationSessionPriceRequired
                      : null;
                },
              ),
              SizedBox(height: AppSpacing.s3),
              AppTextField(
                controller: _monthlyController,
                label: s.monthlyPriceUSD,
                hint: s.monthlyPriceUSDHint,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: const Icon(Icons.calendar_month_rounded),
                validator: (val) {
                  final n = double.tryParse(val ?? '');
                  return (n == null || n <= 0)
                      ? s.validationMonthlyPriceRequired
                      : null;
                },
              ),
              SizedBox(height: AppSpacing.s5),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: s.cancel,
                      variant: AppButtonVariant.outlined,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton(
                      label: s.saveChanges,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
