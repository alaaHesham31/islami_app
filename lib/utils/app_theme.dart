import 'package:flutter/material.dart';

import 'app_colors.dart';

class MyThemeData{
  static final ThemeData myTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.whiteColor,
      unselectedItemColor: AppColors.blackColor,
      showUnselectedLabels: false,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.blackColor,
      iconTheme: IconThemeData(
        color: AppColors.primaryColor
      )
    )
  );

}