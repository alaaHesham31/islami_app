import 'package:flutter/material.dart';
import 'package:islami_app_demo/model/hadeath_model.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';


class HadeathDetailsScreen extends StatelessWidget {
  static const String routeName = 'hadeathScreen';
  const HadeathDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HadeathModel hadeath = ModalRoute.of(context)!.settings.arguments as HadeathModel;
    return Scaffold(
      appBar: AppBar(
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              image: DecorationImage(
                image: AssetImage(AppImage.detailsScreenBackground),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),

              Text(
                hadeath.title,
                style: TextStyle(color: AppColors.primaryColor, fontSize: 20),textAlign: TextAlign.center,

              ),
              SizedBox(height: 20),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    hadeath.content.join(''),
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 20),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
