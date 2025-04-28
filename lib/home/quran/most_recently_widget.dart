import 'package:flutter/material.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';


class MostRecentlyWidget extends StatelessWidget {
  String suraEnName;
  String suraArName;
  String versesNum;

   MostRecentlyWidget({super.key, required this.suraEnName, required this.suraArName, required this.versesNum});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 12),
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
                  suraEnName,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16,),
                Text(
                  suraArName ,
                  style: TextStyle(color: AppColors.blackColor, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16,),

                Text(
                 versesNum ,
                  style: TextStyle(color: AppColors.blackColor,fontSize: 18, fontWeight: FontWeight.w500),
                ),

              ],
            ),
            Image.asset(AppImage.mostRecentlyBackground)
          ],
        ),
      ),
    );
  }
}
