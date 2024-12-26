import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:islami_c13_monday/cache_helper/cache_helper.dart';
import 'package:islami_c13_monday/home/home.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = "/";

  const OnBoardingScreen({super.key});

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    var pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.titleLarge!,
      bodyTextStyle: Theme.of(context).textTheme.headlineSmall!,
      imageFlex: 3,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: const Color(0xFF202020),
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      globalBackgroundColor: const Color(0xFF202020),
      globalHeader: Image.asset("assets/images/onboarding_header.png"),
      dotsFlex: 2,
      dotsDecorator: const DotsDecorator(
          color: Color(0xFF707070),
          activeColor: Color(0xFFE2BE7F),
          spacing: EdgeInsets.all(5)),
      showNextButton: true,
      showBackButton: true,
      back: Text(
        "Back",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      next: Text(
        "Next",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      done: Text(
        "Finish",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      showDoneButton: true,
      onDone: () {
        CacheHelper.saveEligibility();
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      },
      pages: [
        PageViewModel(
          title: "Welcome To Islmi App",
          body: "",
          image: _buildImage('onboarding1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Welcome To Islami",
          body: "We Are Very Excited To Have You In Our Community",
          image: _buildImage('onboarding2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Reading the Quran",
          body: "Read, and your Lord is the Most Generous",
          image: _buildImage('onboarding3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Bearish",
          body: "Praise the name of your Lord, the Most High",
          image: _buildImage('onboarding4.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Holy Quran Radio",
          body:
              "You can listen to the Holy Quran Radio through the application for free and easily",
          image: _buildImage('onboarding5.png'),
          decoration: pageDecoration,
        ),
      ],
    );
  }
}
