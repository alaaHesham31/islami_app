import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app_demo/features/global_player/mini_player.dart';
import 'package:islami_app_demo/home/time/time_tab.dart';
import '../features/hadeath/presentation/pages/hadeath_tab.dart';
import '../features/quran/presentation/screens/quran_tab.dart';
import '../features/radio/presentation/radio_tab.dart';
import '../features/sebha/presentation/sebha_tab.dart';
import '../utils/app_colors.dart';
import '../utils/app_image.dart';
import 'providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = 'homeScreen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(homeTabProvider);

    final tabs = [
       QuranTab(),
       HadeathTab(),
      const SebhaTab(),
       RadioTab(),
      const TimeTab(),
    ];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.quranBackground),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            tabs[selectedIndex],
            const Align(
              alignment: Alignment.bottomCenter,
              child: MiniPlayer(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            ref.read(homeTabProvider.notifier).state = index;
          },
          items: [
            BottomNavigationBarItem(
              label: 'القرآن',
              icon: buildHoverOnSelectedTab(
                selectedIndex: selectedIndex,
                index: 0,
                tabIconPath: AppImage.quranIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'الحديث',
              icon: buildHoverOnSelectedTab(
                selectedIndex: selectedIndex,
                index: 1,
                tabIconPath: AppImage.hadeathIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'السبحة',
              icon: buildHoverOnSelectedTab(
                selectedIndex: selectedIndex,
                index: 2,
                tabIconPath: AppImage.sebhaIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'الراديو',
              icon: buildHoverOnSelectedTab(
                selectedIndex: selectedIndex,
                index: 3,
                tabIconPath: AppImage.radioIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'المواقيت',
              icon: buildHoverOnSelectedTab(
                selectedIndex: selectedIndex,
                index: 4,
                tabIconPath: AppImage.timeIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHoverOnSelectedTab({
    required int selectedIndex,
    required int index,
    required String tabIconPath,
  }) {
    return selectedIndex == index
        ? Container(
      padding:  EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
      // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.blackColorBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ImageIcon(AssetImage(tabIconPath)),
    )
        : ImageIcon(AssetImage(tabIconPath));
  }
}
