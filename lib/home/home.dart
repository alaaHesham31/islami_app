import 'package:flutter/material.dart';
import 'package:islami_c13_monday/home/tabs/ahadeth/ahadeth_tab.dart';
import 'package:islami_c13_monday/home/tabs/quran_tab/quran_tab.dart';
import 'package:islami_c13_monday/home/tabs/radio_tab/radio_tab.dart';
import 'package:islami_c13_monday/home/tabs/sebha/sebha_tab.dart';
import 'package:islami_c13_monday/home/tabs/time_tab/time_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "Home";

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                "assets/images/${getBackgroundImageName(selectedIndex)}.png"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (value) {
              selectedIndex = value;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                  icon: _buildNavItem(0, "quran"), label: "Quran"),
              BottomNavigationBarItem(
                  icon: _buildNavItem(1, "ahadeth"), label: "Ahadeth"),
              BottomNavigationBarItem(
                  icon: _buildNavItem(2, "sebha"), label: "Sebha"),
              BottomNavigationBarItem(
                  icon: _buildNavItem(3, "ic_radio"), label: "Radio"),
              BottomNavigationBarItem(
                  icon: _buildNavItem(4, "dates"), label: "Time"),
            ]),
        body: Column(
          children: [
            Image.asset("assets/images/onboarding_header.png"),
            Expanded(child: tabs[selectedIndex]),
          ],
        ),
      ),
    );
  }

  List<Widget> tabs = [
    QuranTab(),
    AhadethTab(),
    const SebhaTab(),
     RadioTab(),
     TimeTab(),
  ];

  String getBackgroundImageName(index) {
    switch (index) {
      case 0:
        return "home_bg";
      case 1:
        return "ahadeth_bg";
      case 2:
        return "sebha_bg";
      case 3:
        return "radio_bg";
      default:
        return "home_bg";
    }
  }

  Widget _buildNavItem(int index, String imageName) {
    return selectedIndex == index
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0x99202020),
              borderRadius: BorderRadius.circular(66),
            ),
            child: ImageIcon(
              AssetImage("assets/images/$imageName.png"),
            ))
        : ImageIcon(
            AssetImage("assets/images/$imageName.png"),
          );
  }
}
