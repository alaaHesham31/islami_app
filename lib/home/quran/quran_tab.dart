import 'package:flutter/material.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class QuranTab extends StatelessWidget {
  const QuranTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImage.quranBackground))
      ),
      child: Scaffold(

      ),
    );
  }
}
