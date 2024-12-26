import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Color(0xFFE2BE7F),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text(
                          '16 Jul, 2024',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      Column(
                        children: [
                          Text(
                            'Pray Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold

                            ),
                          ),
                          Text(
                            'Tuesday',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold

                            ),
                          ),
                        ],
                      ),
                      Text(
                        '09 Muh, 1446',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    height: screenHeight * 0.15,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPrayerCard('Fajr', '04:04 AM', screenWidth),
                        _buildPrayerCard('Dhuhr', '01:01 PM', screenWidth),
                        _buildPrayerCard('Asr', '04:38 PM', screenWidth),
                        _buildPrayerCard('Maghrib', '07:57 PM', screenWidth),
                        _buildPrayerCard('Isha', '09:30 PM', screenWidth),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Text(
                      'Next Pray: 02:32',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Azkar',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.055,
              ),
              textAlign: TextAlign.start,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.04,
                mainAxisSpacing: screenWidth * 0.04,
                padding: EdgeInsets.all(screenWidth * 0.04),
                children: [
                  _buildAzkarCard('Morning Azkar', screenWidth),
                  _buildAzkarCard('Evening Azkar', screenWidth),
                  _buildAzkarCard('Sleep Azkar', screenWidth),
                  _buildAzkarCard('Prayer Azkar', screenWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerCard(String prayer, String time, double screenWidth) {
    return Container(
      width: screenWidth * 0.25,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF202020), Color(0xFFB19768)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prayer,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.04,
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey,
              fontSize: screenWidth * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAzkarCard(String title, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF202020),
        border: Border.all(color: Color(0xFFE2BE7F)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Image.asset(
                'assets/images/morning_azkar.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.045,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
