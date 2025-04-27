import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/quran/most_recently_widget.dart';
import 'package:islami_app_demo/home/quran/suras_list_widget.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class QuranTab extends StatelessWidget {
  const QuranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImage.quranBackground))
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(AppImage.logoHeader),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Sura Name',
                hintStyle: TextStyle(color: AppColors.whiteColor),
                prefix: Container(
                    color: Colors.red,
                    child: ImageIcon(AssetImage('assets/images/search_icon.png'))),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Most Recently',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            SizedBox(height: 20),
            MostRecentlyWidget(),
            SizedBox(height: 20),
            Text(
              'Most Recently',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            SizedBox(height: 20),
            SurasListWidget(),
          ],
        ),
      ),
    );
  }
}
