import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';


class SebhaTab extends StatefulWidget {
  const SebhaTab({super.key});

  @override
  State<SebhaTab> createState() => _SebhaTabState();
}

class _SebhaTabState extends State<SebhaTab> {
  double rotate = 0.0;
  int currentCount =0;
  final List<String> azkar = ['سبحان الله', 'الله أكبر', 'الحمد لله'];
  int currentZikrIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(AppImage.sebhaBackground)),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  right: 32.0,
                  left: 32.0,
                ),
                child: Image.asset(AppImage.logoHeader),
              ),
              Text(
                'سَبِّحِ اسْمَ رَبِّكَ الأعلى ',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 435,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(AppImage.fixedPartOfSebha),
                    ),

                    Align(
                      alignment: Alignment.center,

                      child: Text(
                    '  ${azkar[currentZikrIndex]}'
                        '\n\n $currentCount',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.rotate(
                        angle: rotate,
                        child: GestureDetector(
                          onTap: onTasbeehClick,
                          child: Image.asset(AppImage.sebhaRotateBody),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTasbeehClick(){
    setState(() {
      rotate += 0.1;
      currentCount ++;
    });
    if(currentCount == 33){
      currentCount = 0;

      currentZikrIndex = (currentZikrIndex +1) % 3;
    }
  }
}
