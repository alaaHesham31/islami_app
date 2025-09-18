import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';
import '../../utils/app_styles.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = 'onboardingScreen';

  OnboardingScreen({super.key});

  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: 'مرحباً بك في تطبيق إسلامي',
      body: '',
      image: Image.asset(AppImage.onboarding1, fit: BoxFit.contain),
      decoration: PageDecoration(
        titleTextStyle: AppStyles.bold22Primary,
      ),
    ),
    PageViewModel(
      title: 'مرحباً بك في تطبيق إسلامي',
      body: 'نحن سعداء بانضمامك إلى مجتمعنا',
      image: SizedBox.expand(child: Image.asset(AppImage.onboarding2)),
      decoration: PageDecoration(
        titleTextStyle: AppStyles.bold22Primary,
        bodyTextStyle: AppStyles.bold16Primary,
      ),
    ),
    PageViewModel(
      title: 'قراءة القرآن الكريم',
      body: 'اقرأ وربك الأكرم',
      image: Center(child: Image.asset(AppImage.onboarding3)),
      decoration: PageDecoration(
        titleTextStyle: AppStyles.bold22Primary,
        bodyTextStyle: AppStyles.bold16Primary,
      ),
    ),
    PageViewModel(
      title: 'التسبيح',
      body: 'سبح اسم ربك الأعلى',
      image: Center(child: Image.asset(AppImage.onboarding4)),
      decoration: PageDecoration(
        titleTextStyle: AppStyles.bold22Primary,
        bodyTextStyle: AppStyles.bold16Primary,
      ),
    ),
    PageViewModel(
      title: 'إذاعة القرآن الكريم',
      body: 'يمكنك الاستماع إلى إذاعة القرآن الكريم بسهولة ومجاناً عبر التطبيق',
      image: Center(child: Image.asset(AppImage.onboarding5)),
      decoration: PageDecoration(
        titleTextStyle: AppStyles.bold22Primary,
        bodyTextStyle: AppStyles.bold16Primary,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.blackColor),
      child: Column(
        children: [
          Image.asset(AppImage.logoHeader, height: 200.h, width: 200.w),
          Expanded(
            child: IntroductionScreen(
              pages: listPagesViewModel,
              showBackButton: true,
              showNextButton: true,
              next: Text(
                "التالي",
                style: AppStyles.bold16Primary,
              ),
              back: Text(
                "السابق",
                style: AppStyles.bold16Primary,
              ),
              done: Text(
                "إنهاء",
                style: AppStyles.bold16Primary,
              ),
              onDone: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              dotsDecorator: DotsDecorator(
                size:  Size.square(10.w),
                activeSize:  Size(20.h, 10.w),
                activeColor: AppColors.primaryColor,
                color: AppColors.grayColor,
                spacing:  EdgeInsets.symmetric(horizontal: 3.w),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
