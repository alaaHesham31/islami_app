import 'package:flutter/material.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class SebhaTab extends StatelessWidget {
  const SebhaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImage.sebhaBackground))
      ),
      child: Scaffold(

      ),
    );
  }
}
