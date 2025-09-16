import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_styles.dart';

class MostRecentlyWidget extends StatelessWidget {
  final String suraEnName;
  final String suraArName;
  final String versesNum;

  const MostRecentlyWidget({
    super.key,
    required this.suraEnName,
    required this.suraArName,
    required this.versesNum,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220.w,
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    suraArName,
                    style: AppStyles.bold16Primary.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '$versesNum آية',
                    style: AppStyles.bold16Primary.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 6,
              child: Image.asset(AppImage.mostRecentlyBackground),
            ),
          ],
        ),
      ),
    );
  }
}
