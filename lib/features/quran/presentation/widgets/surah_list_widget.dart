import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_styles.dart';
import '../../domain/entities/surah.dart';

class SurasListWidget extends StatelessWidget {
  final Sura surahModel;
  final int index;

  const SurasListWidget({
    Key? key,
    required this.surahModel,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(AppImage.vectorNumber),
              Text(
                '${index + 1}',
                style: AppStyles.bold16White,
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${surahModel.verses} آية',
                style: AppStyles.bold16White,
              ),
            ],
          ),
          const Spacer(),
          Text(
            surahModel.arabicName,
            style: AppStyles.bold16White.copyWith(fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
