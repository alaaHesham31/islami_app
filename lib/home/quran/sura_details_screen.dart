import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app_demo/model/sura_model.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class SuraDetailsScreen extends StatefulWidget {
  static const String routeName = 'suraDetailsScreen';

  SuraDetailsScreen({super.key});

  @override
  State<SuraDetailsScreen> createState() => _SuraDetailsScreenState();
}

class _SuraDetailsScreenState extends State<SuraDetailsScreen> {
  List<String> verses = [];

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as SuraModel;
    if (verses.isEmpty) {
      loadSuraFiles(args.index);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          args.suraEnglishName,
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              image: DecorationImage(
                image: AssetImage(AppImage.quranDetailsBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),

              Text(
                args.suraArabichName,
                style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: verses.length,
                  itemBuilder: (context, index) {
                    return verses.isEmpty
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 32.0,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primaryColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                               ' ${verses[index]} [${index+1}]',
                                style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void loadSuraFiles(int index) async {
    String suraContent = await rootBundle.loadString(
      'assets/files/${index + 1}.txt',
    );
    List<String> suraLines = suraContent.split('\n');
    verses = suraLines;

    setState(() {});
  }
}
