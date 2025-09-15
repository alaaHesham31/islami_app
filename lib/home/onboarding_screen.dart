import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:islami_app_demo/home/home_screen.dart';

import '../utils/app_colors.dart';
import '../utils/app_image.dart';


class OnboardingScreen extends StatelessWidget {
  static const String routeName = 'onboardingScreen';

  OnboardingScreen({super.key});

  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: 'Welcome To Islmi App',
      body: '',
      image: Image.asset(AppImage.onboarding1, fit: BoxFit.contain, ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    ),
    PageViewModel(
      title: 'Welcome To Islmi App',
      body: 'We Are Very Excited To Have You In Our Community',
      image: SizedBox.expand(child: Image.asset(AppImage.onboarding2)),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        bodyTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    ),
    PageViewModel(
      title: 'Reading the Quran',
      body: 'Read, and your Lord is the Most Generous',
      image: Center(child: Image.asset(AppImage.onboarding3)),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        bodyTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    ),
    PageViewModel(
      title: 'Bearish',
      body: 'Praise the name of your Lord, the Most High',
      image: Center(child: Image.asset(AppImage.onboarding4)),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        bodyTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    ),
    PageViewModel(
      title: 'Holy Quran Radio',
      body:
          'You can listen to the Holy Quran Radio through the application for free and easily',
      image: Center(child: Image.asset(AppImage.onboarding5)),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        bodyTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.blackColor),
      child: Column(
        children: [
          Image.asset(AppImage.logoHeader, height: 200, width: 200,),
          Expanded(
            child: IntroductionScreen(
              pages: listPagesViewModel,
              showBackButton: true,
              showNextButton: true,
              next: const Text(
                "Next",
                style: TextStyle(color: AppColors.primaryColor),
              ),
              back: const Text(
                "Back",
                style: TextStyle(color: AppColors.primaryColor),
              ),
              done: const Text(
                "Finish",
                style: TextStyle(color: AppColors.primaryColor),
              ),
              onDone: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: AppColors.primaryColor,

                color: AppColors.grayColor,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
