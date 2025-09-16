import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../data/datasources/hadeath_local_data_source.dart';
import '../../data/repositories/hadeath_repository_impl.dart';
import '../../domain/entities/hadeath.dart';
import '../../domain/repositories/hadeath_repository.dart';
import '../widgets/hadeath_card.dart';
import 'hadeath_details_screen.dart';

class HadeathTab extends StatefulWidget {
  const HadeathTab({super.key});

  @override
  State<HadeathTab> createState() => _HadeathTabState();
}

class _HadeathTabState extends State<HadeathTab> {
  late final HadeathRepository repository;
  List<Hadeath> hadeathList = [];
  PageController pageController = PageController(viewportFraction: 0.75);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    repository = HadeathRepositoryImpl(HadeathLocalDataSource());
    _loadData();

    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page?.round() ?? 0;
      });
    });
  }

  Future<void> _loadData() async {
    final data = await repository.getAllAhadeeth();
    setState(() {
      hadeathList = data;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.hadeathBackground),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.h, right: 32.w, left: 32.w),
              child: Image.asset(AppImage.logoHeader),
            ),
            Expanded(
              child: hadeathList.isEmpty
                  ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                  : PageView.builder(
                controller: pageController,
                itemCount: hadeathList.length,
                itemBuilder: (context, index) {
                  double scale = currentPage == index ? 1.0 : 0.8;

                  return TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 350),
                    tween: Tween(begin: scale, end: scale),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              HadeathDetailsScreen.routeName,
                              arguments: hadeathList[index],
                            );
                          },
                          child: HadeathCard(hadeath: hadeathList[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
