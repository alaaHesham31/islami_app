import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/quran/most_recently_widget.dart';
import 'package:islami_app_demo/home/quran/sura_details_screen.dart';
import 'package:islami_app_demo/home/quran/suras_list_widget.dart';
import 'package:islami_app_demo/model/sura_model.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class QuranTab extends StatelessWidget {
  QuranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImage.quranBackground)),
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
                  child: ImageIcon(AssetImage('assets/images/search_icon.png')),
                ),
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
            Text('Suras List', style: TextStyle(color: AppColors.whiteColor)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: SuraModel.getSurasCount(),
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      height: 2,
                      indent: 30,
                      endIndent: 30,
                      color: AppColors.primaryColor,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SuraDetailsScreen.routeName, arguments: SuraModel.getSuraModel(index));
                    },
                    child: SurasListWidget(
                      suraModel: SuraModel.getSuraModel(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
