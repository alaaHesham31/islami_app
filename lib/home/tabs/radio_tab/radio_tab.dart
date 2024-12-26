import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.04,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTabIndex == 0
                          ? const Color(0xFFE2BE7F)
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Radio",
                      style: TextStyle(
                        color: _selectedTabIndex == 0 ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTabIndex == 1
                          ? const Color(0xFFE2BE7F)
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Reciters",
                      style: TextStyle(
                        color: _selectedTabIndex == 1 ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildRadioTab(screenWidth, screenHeight)
                : _buildRecitersTab(screenWidth, screenHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTab(double screenWidth, double screenHeight) {
    return ListView(
      padding: EdgeInsets.all(screenWidth * 0.02),
      children: [
        radioContainer("Ibrahim Al-Akdar", screenWidth, screenHeight),
        radioContainer("Akram Alalaqmi", screenWidth, screenHeight),
        radioContainer("Majed Al-Enezi", screenWidth, screenHeight),
        radioContainer("Malik Shaibat Alhamed", screenWidth, screenHeight),
      ],
    );
  }

  Widget _buildRecitersTab(double screenWidth, double screenHeight) {
    return ListView(
      padding: EdgeInsets.all(screenWidth * 0.02),
      children: [
        radioContainer("Ibrahim Al-Akdar", screenWidth, screenHeight),
        radioContainer("Akram Alalaqmi", screenWidth, screenHeight),
        radioContainer("Majed Al-Enezi", screenWidth, screenHeight),
        radioContainer("Malik Shaibat Alhamed", screenWidth, screenHeight),
      ],
    );
  }

  Widget radioContainer(String title, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: const Color(0xFFE2BE7F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Image.asset(
                  'assets/images/mosque_bg.png',
                  height: screenHeight * 0.1,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Play and Volume Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: screenWidth * 0.08, color: Colors.black),
                  SizedBox(width: screenWidth * 0.04),
                  Icon(Icons.volume_up, size: screenWidth * 0.06, color: Colors.black),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
