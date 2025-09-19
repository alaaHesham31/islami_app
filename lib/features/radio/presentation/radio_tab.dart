import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../reciters/presentation/pages/reciters_sub_tab.dart';
import 'radio_sub_tab.dart';

class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                children: [
                  Image.asset(AppImage.logoHeader,height: 140.h, width: 200.w),
                  // SizedBox(height: 20.h,),
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF202020B2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        controller: _controller,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.primaryColor,
                        ),
                        tabs: const [
                          Text(' الراديو'),
                          Text(' المقرئين'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: TabBarView(
                        controller: _controller,
                        children: const [
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
        ),
      ),
    );
  }
}
