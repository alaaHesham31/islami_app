import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami_app_demo/home/hadeath/hadeath_details_screen.dart';
import 'package:islami_app_demo/model/hadeath_model.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';


class HadeathCard extends StatelessWidget {
   HadeathCard({super.key, required this.hadeathList});
  List<HadeathModel> hadeathList;




  @override
  Widget build(BuildContext context) {
    loadHadeathFile();
    return  Expanded(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, HadeathDetailsScreen.routeName);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Image(
                image: AssetImage(AppImage.hadeathCardBackground),
                fit: BoxFit.fill,
              ),
              Text('')
            ],
          ),
        ),
      ),
    );
  }

  void loadHadeathFile() async{
    for(int i =1; i<= 50; i++) {
      String hadeathContent = await rootBundle.loadString(
          'assets/files/hadeath/h$i.txt');
      List<String> hadeathLines = hadeathContent.split('\n');
      String title = hadeathLines[0]; //title
      hadeathLines.removeAt(0);      // content
      hadeathList.add(HadeathModel(title: title, content: hadeathLines));
      print(HadeathModel(title: title, content: hadeathLines));

    }

  }
}
