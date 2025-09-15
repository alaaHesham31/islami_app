import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/hadeath/hadeath_tab.dart';
import 'package:islami_app_demo/home/quran/quran_tab.dart';
import 'package:islami_app_demo/home/radio/radio_tab.dart';
import 'package:islami_app_demo/home/radio/global_player/mini_player.dart';
import 'package:islami_app_demo/home/sebha/sebha_tab.dart';
import 'package:islami_app_demo/home/time/time_tab.dart';


import '../utils/app_colors.dart';
import '../utils/app_image.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'homeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 4;

  final List<Widget> tabs = [
    QuranTab(),
    HadeathTab(),
    const SebhaTab(),
    RadioTab(),
    TimeTab(),
  ];

  @override
  Widget build(BuildContext context) {
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
            Align(alignment: Alignment.bottomCenter, child: const MiniPlayer()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: 'Quran',
              icon: buildHoverOnSelectedTab(
                index: 0,
                tabIconPath: AppImage.quranIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Hadeath',
              icon: buildHoverOnSelectedTab(
                index: 1,
                tabIconPath: AppImage.hadeathIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Sebha',
              icon: buildHoverOnSelectedTab(
                index: 2,
                tabIconPath: AppImage.sebhaIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Radio',
              icon: buildHoverOnSelectedTab(
                index: 3,
                tabIconPath: AppImage.radioIcon,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Time',
              icon: buildHoverOnSelectedTab(
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
    required int index,
    required String tabIconPath,
  }) {
    return selectedIndex == index
        ? Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.blackColorBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ImageIcon(AssetImage(tabIconPath)),
        )
        : ImageIcon(AssetImage(tabIconPath));
  }
}
