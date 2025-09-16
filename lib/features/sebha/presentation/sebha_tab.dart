import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_image.dart';
import '../../../utils/app_styles.dart';
import '../../sebha/application/sebha_notifier.dart';

class SebhaTab extends ConsumerStatefulWidget {
  const SebhaTab({Key? key}) : super(key: key);

  @override
  ConsumerState<SebhaTab> createState() => _SebhaTabState();
}

class _SebhaTabState extends ConsumerState<SebhaTab> {
  double rotate = 0.0;

  @override
  Widget build(BuildContext context) {
    final zikr = ref.watch(sebhaProvider);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.sebhaBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 16.h,
                  right: 32.w,
                  left: 32.w,
                ),
                child: Image.asset(AppImage.logoHeader),
              ),
              Text(
                'سَبِّحِ اسْمَ رَبِّكَ الأعلى',
                style: AppStyles.bold20White.copyWith(fontSize: 32.sp),
              ),
              SizedBox(height: 20.h,),
              SizedBox(
                width: double.infinity,
                height: 490.h,
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
                        '${zikr.text}\n\n${zikr.count}',
                        style: AppStyles.bold20White.copyWith(fontSize: 32.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.rotate(
                        angle: rotate,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              rotate += 0.1;
                            });
                            ref.read(sebhaProvider.notifier).onTasbeehClick();
                          },
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
}
