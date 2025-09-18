import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:workmanager/workmanager.dart';
import 'features/home/home_screen.dart';
import 'features/time/azkar/azkar_details_screen.dart';
import 'features/home/onboarding_screen.dart';
import 'features/hadeath/presentation/pages/hadeath_details_screen.dart';
import 'features/quran/presentation/widgets/surah_details_screen.dart';

import 'services/notifications_services/notification_service.dart';
import 'services/hive/hive_initializer.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timezones (required for flutter_local_notifications)
  tzdata.initializeTimeZones();

  // Local storage + notifications
  await initHive();
  await NotificationService.init();
  await NotificationService.requestPermissionsAndLog();

  // Schedule all cached prayer times for the next 31 days
  await NotificationService.scheduleMonthFromHive(
    minutesBefore: 10,
    daysAhead: 31,
  );

  // Background worker: ensures cache refreshes periodically
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false, //  set false for release
  );

  await Workmanager().registerPeriodicTask(
    "refreshPrayerTask",
    "refreshPrayerTimes",
    frequency: const Duration(hours: 48),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

/// Runs in background isolate (WorkManager callback)
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "refreshPrayerTimes":
        final valid = await NotificationService.cacheIsStillValid(daysAhead: 7);
        if (!valid) {
          await NotificationService.scheduleMonthFromHive();
          debugPrint('🔄 Cache refreshed in background');
        } else {
          debugPrint('✅ Cache still valid, skipping refresh');
        }
        break;
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar')],
          initialRoute: HomeScreen.routeName,
          routes: {
            OnboardingScreen.routeName: (_) => OnboardingScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
            SuraDetailsScreen.routeName: (_) => SuraDetailsScreen(),
            HadeathDetailsScreen.routeName: (_) => HadeathDetailsScreen(),
            AzkarDetailsScreen.routeName: (_) => AzkarDetailsScreen(),
          },
          theme: MyThemeData.myTheme,
        );
      },
    );
  }
}
