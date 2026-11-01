import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/app_settings/presentation/view_model/app_settings_cubit/app_settings_cubit.dart';
import '../../../../core/app_settings/presentation/view_model/app_settings_cubit/app_settings_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/presentation/widgets/contact_support_dialog.dart';
import 'coach_account_danger_zone.dart';

class CoachAccountSettingsSection extends StatelessWidget {
  const CoachAccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgAll,
            side: BorderSide(color: border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.accountAndPreferences,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.s3),
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                builder: (context, settings) {
                  final isAr = settings.locale.languageCode == 'ar';
                  final cubit = context.read<AppSettingsCubit>();
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.language_rounded,
                            color: AppColors.flameRed),
                        title: Text(s.languageSetting,
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          isAr ? s.arabicLanguage : s.englishLanguage,
                          style: TextStyle(
                              fontSize: 11.sp, color: textSecondary),
                        ),
                        trailing: Switch(
                          value: isAr,
                          activeThumbColor: AppColors.flameRed,
                          onChanged: (v) => cubit.setLanguage(v ? 'ar' : 'en'),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.notifications_active_rounded,
                            color: AppColors.flameRed),
                        title: Text(s.pushNotifications,
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          s.pushNotificationsDesc,
                          style: TextStyle(
                              fontSize: 11.sp, color: textSecondary),
                        ),
                        trailing: Switch(
                          value: settings.notificationsEnabled,
                          activeThumbColor: AppColors.flameRed,
                          onChanged: cubit.toggleNotifications,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.help_outline_rounded,
                    color: AppColors.secondary),
                title: Text(s.helpAndSupport,
                    style: TextStyle(
                        fontSize: 13.sp, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  s.helpAndSupportDesc,
                  style: TextStyle(fontSize: 11.sp, color: textSecondary),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => ContactSupportDialog.show(context),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: AppSpacing.s4),
        const CoachAccountDangerZone(),
      ],
    );
  }
}
