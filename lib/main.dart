import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app_settings/presentation/view_model/app_settings_cubit/app_settings_cubit.dart';
import 'core/app_settings/presentation/view_model/app_settings_cubit/app_settings_state.dart';
import 'core/locator_service/service_locator.dart';
import 'core/navigator/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service/notification_service.dart';
import 'generated/l10n.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupServiceLocator();
  await getIt<NotificationService>().initialize();
  runApp(const CoachHubApp());
}

class CoachHubApp extends StatelessWidget {
  const CoachHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppSettingsCubit>()..loadSettings(),
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settings) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'CoachHub',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.darkTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.dark,
                locale: settings.locale,
                routerConfig: AppRouter.router,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
              );
            },
          );
        },
      ),
    );
  }
}

