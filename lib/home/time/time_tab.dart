import 'package:flutter/material.dart';
import 'package:islami_app_demo/theme/app_image.dart';

class TimeTab extends StatelessWidget {
  const TimeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImage.timeBackground))
      ),
      child: Scaffold(

      ),
    );
  }
}
