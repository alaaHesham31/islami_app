import 'package:flutter/material.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class HadeathTab extends StatelessWidget {
  const HadeathTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImage.hadeathBackground), fit: BoxFit.fill),
      ),
      child: Scaffold(),
    );
  }
}
