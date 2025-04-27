import 'package:flutter/material.dart';

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
