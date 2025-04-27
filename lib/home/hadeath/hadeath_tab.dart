import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app_demo/home/hadeath/hadeath_details_screen.dart';
import 'package:islami_app_demo/model/hadeath_model.dart';
import 'package:islami_app_demo/theme/app_colors.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class HadeathTab extends StatefulWidget {
  @override
  State<HadeathTab> createState() => _HadeathTabState();
}

class _HadeathTabState extends State<HadeathTab> {
  List<HadeathModel> hadeathList = [];
  PageController pageController = PageController(viewportFraction: 0.75);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadHadeathFile();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.hadeathBackground),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                right: 32.0,
                left: 32.0,
              ),
              child: Image.asset(AppImage.logoHeader),
            ),
            Expanded(
              child: hadeathList.isEmpty
                  ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
                  : PageView.builder(
                controller: pageController,
                itemCount: hadeathList.length,
                itemBuilder: (context, index) {
                  double scale = currentPage == index ? 1.0 : 0.8;

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 350),
                    tween: Tween(begin: scale, end: scale),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, HadeathDetailsScreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                            padding: EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    AppImage.hadeathCardBackground,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      hadeathList[index].title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                          child: Text(
                                            hadeathList[index].content.join(' '),
                                            style: TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,

                                            ),
                                            maxLines: 15,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadHadeathFile() async {
    for (int i = 1; i <= 50; i++) {
      String hadeathContent = await rootBundle.loadString(
        'assets/files/hadeath/h$i.txt',
      );
      List<String> hadeathLines = hadeathContent.split('\n');
      String title = hadeathLines[0];
      hadeathLines.removeAt(0);
      hadeathList.add(HadeathModel(title: title, content: hadeathLines));
    }
    setState(() {});
  }
}
