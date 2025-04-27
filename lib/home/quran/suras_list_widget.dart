import 'package:flutter/material.dart';
import 'package:islami_app_demo/model/sura_model.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class SurasListWidget extends StatelessWidget {
  SurasListWidget({super.key, required this.suraModel});

  SuraModel suraModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AppImage.vectorNumber),
            Text(
              '${suraModel.index +1 }',
              style: TextStyle(color: AppColors.whiteColor),
            ),
          ],
        ),
        SizedBox(width: 16),
        Column(
          children: [
            Text(
              suraModel.suraEnglishName,
              style: TextStyle(color: AppColors.whiteColor),
            ),
            Text(
              '${suraModel.versesNumber} Verses',
              style: TextStyle(color: AppColors.whiteColor),
            ),
          ],
        ),
        Spacer(),
        Text(
          suraModel.suraArabichName,
          style: TextStyle(color: AppColors.whiteColor, fontSize: 18),
        ),
      ],
    );
  }
}
