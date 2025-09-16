import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app_demo/shared/hive_initializer.dart';
import 'package:islami_app_demo/home/home_screen.dart';
import 'package:islami_app_demo/home/onboarding_screen.dart';
import 'package:islami_app_demo/home/time/azkar/azkar_details_screen.dart';
import 'package:islami_app_demo/services/notification_service.dart';
import 'package:islami_app_demo/utils/app_theme.dart';

import 'features/hadeath/presentation/pages/hadeath_details_screen.dart';
import 'features/quran/presentation/widgets/surah_details_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();
  await NotificationService.init();
  await NotificationService.requestPermission();

  // schedule all prayer notifications
  await NotificationService.schedulePrayerNotifications();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932), // iPhone 14 Pro Max reference
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),

          // i18n delegates
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('ar'),
          ],
          initialRoute: HomeScreen.routeName,
          routes: {
            OnboardingScreen.routeName: (_) => OnboardingScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
            SuraDetailsScreen.routeName: (_) => SuraDetailsScreen(),
            HadeathDetailsScreen.routeName: (_) => HadeathDetailsScreen(),
            AzkarDetailsScreen.routeName: (_) => AzkarDetailsScreen(),
            // ReciterSurahListScreen.routeName: (_) => ReciterSurahListScreen(),
          },
          theme: MyThemeData.myTheme,
        );
      },
    );
  }
}
