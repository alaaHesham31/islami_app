import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:islami_app_demo/home/quran/most_recently_widget.dart';
import 'package:islami_app_demo/home/quran/sura_details_screen.dart';
import 'package:islami_app_demo/home/quran/suras_list_widget.dart';
import 'package:islami_app_demo/model/sura_model.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranTab extends StatefulWidget {
  QuranTab({super.key});

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  String searchedText = '';
  List<SuraModel> filtredList = SuraModel.suraList;

  List<List<String>> loadSuraList = [];

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
    super.initState();
    addSuraList();
    loadLastSura();
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
                    searchedText.isNotEmpty
                        ? SizedBox()
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Most Recently',
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            SizedBox(height: 20),

                            loadSuraList.isEmpty
                                ? Center(
                              child: Text(
                                'No recently read sura yet',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            )
                                : SizedBox(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: loadSuraList.length,
                                itemBuilder: (context, index) {
                                  if (loadSuraList[index].length != 3) {
                                    // Skip rendering malformed entries
                                    return SizedBox.shrink();
                                  }
                                  return MostRecentlyWidget(
                                    suraEnName: loadSuraList[index][0],
                                    suraArName: loadSuraList[index][1],
                                    versesNum: loadSuraList[index][2],
                                  );
                                },
                              ),
                            )
                            ,
                          ],
                        ),
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
                              storeLastSura(
                                suraEnName: filtredList[index].suraEnglishName,
                                suraArName: filtredList[index].suraArabichName,
                                versesNum: filtredList[index].versesNumber,
                              );
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


  storeLastSura({
    required String suraEnName,
    required String suraArName,
    required String versesNum,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get existing recent suras
    List<String> encodedList = prefs.getStringList('recentSuras') ?? [];
    List<List<String>> recentSuras = encodedList
        .map((e) => List<String>.from(jsonDecode(e)))
        .toList();

    // Add new sura to top, avoiding duplicates
    recentSuras.removeWhere((item) => item[0] == suraEnName); // optional: prevent duplicate sura
    recentSuras.insert(0, [suraEnName, suraArName, versesNum]);

    // Keep only latest 5 or 10 items (optional)
    if (recentSuras.length > 10) recentSuras = recentSuras.sublist(0, 10);

    // Store back
    await prefs.setStringList(
      'recentSuras',
      recentSuras.map((e) => jsonEncode(e)).toList(),
    );

    await loadLastSura();
  }


  getLastSura() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> encodedList = prefs.getStringList('recentSuras') ?? [];
    List<List<String>> decodedList = encodedList
        .map((e) => List<String>.from(jsonDecode(e)))
        .toList();
    return decodedList;
  }


  loadLastSura() async {
    final data = await getLastSura();
    loadSuraList = data.where((item) => item.length == 3).toList();
    setState(() {});
  }

}
