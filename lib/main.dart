import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/hadeath/hadeath_details_screen.dart';
import 'package:islami_app_demo/home/home_screen.dart';
import 'package:islami_app_demo/home/onboarding_screen.dart';
import 'package:islami_app_demo/home/quran/sura_details_screen.dart';
import 'package:islami_app_demo/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        OnboardingScreen.routeName : (context) => OnboardingScreen(),
        HomeScreen.routeName : (context) => HomeScreen(),
        SuraDetailsScreen.routeName : (context) => SuraDetailsScreen(),
        HadeathDetailsScreen.routeName : (context) => HadeathDetailsScreen(),


      },
      theme: MyThemeData.myTheme,

    );
  }
}
