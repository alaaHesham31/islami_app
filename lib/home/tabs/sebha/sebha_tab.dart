import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SebhaTab extends StatefulWidget {
  const SebhaTab({super.key});

  @override
  State<SebhaTab> createState() => _SebhaTabState();
}

class _SebhaTabState extends State<SebhaTab> with SingleTickerProviderStateMixin {
  final List<String> azkar = ['سبحان الله', 'الله أكبر', 'الحمد لله'];
  int currentZikrIndex = 0;
  int currentCount = 0;
  double rotationAngle = 0.0;

  void onTasbeehClick() {
    setState(() {
      rotationAngle += pi / 6;
      currentCount++;

      if (currentCount == 33) {
        currentCount = 0;
        currentZikrIndex = (currentZikrIndex + 1) % azkar.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double sebhaSize = screenWidth * 0.8;
    double textSize = screenWidth * 0.07;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              'سَبِّحِ اسْمَ رَبِّكَ الأعلى',
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              children: [
                Positioned(
                  top: -screenHeight * 0.08,
                  left: screenWidth * 0.35,
                  child: Image.asset(
                    'assets/images/sebha_fixed.png',
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                  ),
                ),
                GestureDetector(
                  onTap: onTasbeehClick,
                  child: Center(
                    child: SizedBox(
                      width: sebhaSize,
                      height: sebhaSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: rotationAngle,
                            child: Image.asset(
                              'assets/images/sebha_circle.png',
                              width: sebhaSize,
                              height: sebhaSize,
                            ),
                          ),
                          Positioned(
                            top: sebhaSize * 0.35,
                            child: Text(
                              azkar[currentZikrIndex],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: sebhaSize * 0.45,
                            child: Text(
                              '$currentCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: textSize * 1.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
  }
}
