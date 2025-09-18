import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_styles.dart';
import '../../domain/entities/hadeath.dart';

class HadeathDetailsScreen extends StatelessWidget {
  static const String routeName = 'hadeathScreen';
  const HadeathDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hadeath = ModalRoute.of(context)!.settings.arguments as Hadeath;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          hadeath.title,
          style: AppStyles.bold20Primary,
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30.h),
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              image: DecorationImage(
                image: AssetImage(AppImage.detailsScreenBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),

                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      hadeath.content.join(' '),
                      style: AppStyles.semi22Primary,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
