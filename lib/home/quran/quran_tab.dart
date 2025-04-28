import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/quran/most_recently_widget.dart';
import 'package:islami_app_demo/home/quran/sura_details_screen.dart';
import 'package:islami_app_demo/home/quran/suras_list_widget.dart';
import 'package:islami_app_demo/model/sura_model.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class QuranTab extends StatefulWidget {
  QuranTab({super.key});

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  String searchedText = '';
  List<SuraModel> filtredList = SuraModel.suraList;

  void addSuraList() {
    for (int i = 0; i < 114; i++) {
      SuraModel.suraList.add(
        SuraModel(
          suraEnglishName: SuraModel.englishQuranSurahsList[i],
          suraArabichName: SuraModel.arabicAuranSurasList[i],
          versesNumber: SuraModel.VersesNumberList[i],
          fileName: '${i + 1}.txt',
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addSuraList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImage.quranBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(AppImage.logoHeader),
                    TextFormField(
                      onChanged: (text) {
                        searchedText = text;
                        filtredList =
                            SuraModel.suraList.where((suraModel) {
                              return suraModel.suraArabichName.contains(
                                    searchedText,
                                  ) ||
                                  suraModel.suraEnglishName
                                      .toLowerCase()
                                      .contains(searchedText.toLowerCase());
                            }).toList();
                        setState(() {});
                      },
                      style: TextStyle(color: AppColors.whiteColor),
                      cursorColor: AppColors.whiteColor,
                      decoration: InputDecoration(
                        hintText: 'Sura Name',
                        hintStyle: TextStyle(color: AppColors.whiteColor),
                        prefixIcon: ImageIcon(
                          AssetImage(AppImage.searchIcon),
                          color: AppColors.primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    searchedText.isNotEmpty ? SizedBox() : MostRecentlyWidget(),
                    SizedBox(height: 20),
                    Text(
                      'Sura List',
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 400,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: filtredList.length,
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
                              Navigator.pushNamed(
                                context,
                                SuraDetailsScreen.routeName,
                                arguments: filtredList[index],
                              );
                            },
                            child: SurasListWidget(
                              suraModel: filtredList[index],
                              index: index,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
