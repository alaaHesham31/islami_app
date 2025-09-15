import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/radio/radio_sub_tab/radio_sub_tab.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciters_sub_tab.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';


class RadioTab extends StatefulWidget {
  RadioTab({super.key});

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImage.radioBackground)),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(AppImage.logoHeader),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF202020B2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    labelStyle: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    controller: _controller,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primaryColor,
                    ),
                    tabs: [Text('Radio'), Text('Reciters')],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                  child: TabBarView(
                    controller: _controller,

                    children: [
                      RadioSubTabContent(),
                      RecitersSubTab(),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
