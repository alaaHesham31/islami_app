import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_styles.dart';
import '../../domain/entities/hadeath.dart';

class HadeathCard extends StatelessWidget {
  final Hadeath hadeath;

  const HadeathCard({super.key, required this.hadeath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
      padding: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImage.hadeathCardBackground, fit: BoxFit.fill),
          ),
          Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                hadeath.title,
                style: AppStyles.bold20Black,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    hadeath.content.join(' '),
                    style: AppStyles.semi18Black.copyWith(overflow: TextOverflow.ellipsis),
                    maxLines: 15,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
