import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/services/hive_helper/hive_initializer.dart';
import 'package:islami_app_demo/home/hadeath/hadeath_details_screen.dart';
import 'package:islami_app_demo/home/home_screen.dart';
import 'package:islami_app_demo/home/onboarding_screen.dart';
import 'package:islami_app_demo/home/quran/sura_details_screen.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_surah_list_screen.dart';
import 'package:islami_app_demo/home/time/azkar/azkar_details_screen.dart';
import 'package:islami_app_demo/services/location_helper.dart';
import 'package:islami_app_demo/services/notification_service.dart';
import 'package:islami_app_demo/theme/app_theme.dart';

import 'home/time/prayer_times/prayer_repository.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  await NotificationService.init();

  // begin prayer times flow
  try {
    final loc = await LocationService.getCurrentLocation();
    final repo = PrayerRepository();
    // only Perform heavy sync once per month (repo implements that)
    final times = await repo.getPrayerTimes(loc.latitude, loc.longitude, forceRefresh: false);

    // schedule notifications (skip items already passed and move them to tomorrow)
    await NotificationService.cancelAll(); // clear previous day's schedules
    final now = DateTime.now();
    for (final e in times.entries) {
      var scheduled = e.value;
      if (!scheduled.isAfter(now)) {
        // move to next day (preferred UX: schedule next occurrence)
        scheduled = scheduled.add(const Duration(days: 1));
        debugPrint('! ${e.key} was in the past, moved to tomorrow: $scheduled');
      }
      debugPrint('📌 Scheduling ${e.key} at $scheduled');
      await NotificationService.scheduleZoned(
        id: e.key.hashCode,
        title: '${e.key} Prayer',
        body: "It's time for ${e.key}",
        localDateTime: scheduled,
        dailyRepeat: true,
      );
    }
    await NotificationService.debugPending();
  } catch (e) {
    debugPrint('❌ Failed scheduling prayers: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SuraDetailsScreen.routeName: (context) => SuraDetailsScreen(),
        HadeathDetailsScreen.routeName: (context) => HadeathDetailsScreen(),
        AzkarDetailsScreen.routeName: (context) => AzkarDetailsScreen(),
        ReciterSurahListScreen.routeName: (context) => ReciterSurahListScreen(),
      },
      theme: MyThemeData.myTheme,
    );
  }
}
