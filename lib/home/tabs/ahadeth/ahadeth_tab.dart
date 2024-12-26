import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami_c13_monday/hadeth_details/hadeth_details.dart';
import 'package:islami_c13_monday/models/hadeth_model.dart';
import 'package:islami_c13_monday/my_theme_data.dart';

class AhadethTab extends StatefulWidget {
  AhadethTab({super.key});

  @override
  State<AhadethTab> createState() => _AhadethTabState();
}

class _AhadethTabState extends State<AhadethTab> {
  List<HadethModel> allAhadeth = [];

  @override
  Widget build(BuildContext context) {
    if (allAhadeth.isEmpty) {
      loadHadethFile();
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: double.infinity,
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
            ),
            items: allAhadeth.map((hadeth) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        HadethDetailsScreen.routeName,
                        arguments: hadeth,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset(
                            "assets/images/hadeth_bg.png",
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.6,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: screenHeight * 0.03),
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                child: Text(
                                  hadeth.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: screenWidth * 0.05,
                                    color: MyThemeData.blackColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                  child: Text(
                                    hadeth.content.first,
                                    textAlign: TextAlign.center,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: screenWidth * 0.04,
                                      color: MyThemeData.blackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
      ],
    );
  }

  void loadHadethFile() {
    rootBundle.loadString("assets/files/ahadeth.txt").then(
          (file) {
        List<String> ahadeth = file.split("#");

        for (String data in ahadeth) {
          List<String> lines = data.trim().split("\n");
          String title = lines[0];
          lines.removeAt(0);
          List<String> content = lines;
          HadethModel hadethModel = HadethModel(title, content);
          allAhadeth.add(hadethModel);
        }
        setState(() {});
      },
    ).catchError((error) {
      print("Error Details : $error");
    });
  }
}
