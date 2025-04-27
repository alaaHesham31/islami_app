import 'package:flutter/material.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';


class MostRecentlyWidget extends StatelessWidget {
  const MostRecentlyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'EnSuraName',
                style: TextStyle(color: AppColors.blackColor, fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16,),
              Text(
                'ArSuraName',
                style: TextStyle(color: AppColors.blackColor, fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16,),

              Text(
                'AyaNumber',
                style: TextStyle(color: AppColors.blackColor,fontSize: 18, fontWeight: FontWeight.w500),
              ),

            ],
          ),
          Image.asset(AppImage.mostRecentlyBackground)
        ],
      ),
    );
  }
}
