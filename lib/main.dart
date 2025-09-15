import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/services/hive_helper/hive_initializer.dart';
import 'package:islami_app_demo/home/hadeath/hadeath_details_screen.dart';
import 'package:islami_app_demo/home/home_screen.dart';
import 'package:islami_app_demo/home/onboarding_screen.dart';
import 'package:islami_app_demo/home/quran/sura_details_screen.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_surah_list_screen.dart';
import 'package:islami_app_demo/home/time/azkar/azkar_details_screen.dart';
import 'package:islami_app_demo/services/notification_service.dart';
import 'package:islami_app_demo/utils/app_theme.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        OnboardingScreen.routeName: (_) => OnboardingScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        SuraDetailsScreen.routeName: (_) => SuraDetailsScreen(),
        HadeathDetailsScreen.routeName: (_) => HadeathDetailsScreen(),
        AzkarDetailsScreen.routeName: (_) => AzkarDetailsScreen(),
        ReciterSurahListScreen.routeName: (_) => ReciterSurahListScreen(),
      },
      theme: MyThemeData.myTheme,
    );
  }
}
