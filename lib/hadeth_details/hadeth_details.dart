import 'package:flutter/material.dart';
import 'package:islami_c13_monday/models/hadeth_model.dart';

class HadethDetailsScreen extends StatelessWidget {
  static const String routeName = "HadethDetails";

  const HadethDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute.of(context)?.settings.arguments as HadethModel;
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            "assets/images/details_bg.png",
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    model.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: model.content[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: model.content.length,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
