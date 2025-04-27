import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/home_screen.dart';
import 'package:islami_app_demo/home/onboarding_screen.dart';
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
      initialRoute: OnboardingScreen.routeName,
      routes: {
        OnboardingScreen.routeName : (context) => OnboardingScreen(),
        HomeScreen.routeName : (context) => HomeScreen(),

      },
      theme: MyThemeData.myTheme,

    );
  }
}
