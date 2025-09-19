import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_styles.dart';
import '../../global_player/global_play_states.dart';
import '../../global_player/global_player_notifier.dart';
import '../application/radio_notifier.dart';

class RadioSubTabContent extends ConsumerWidget {
  const RadioSubTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radiosAsync = ref.watch(radioListProvider);
    final playerState = ref.watch(globalPlayerProvider);
    final player = ref.read(globalPlayerProvider.notifier);

    return radiosAsync.when(
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
      error:
          (err, stack) => Padding(
            padding:  EdgeInsets.only(top:40.0.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, color: AppColors.whiteColor, size: 48.sp),
                SizedBox(height: 12),
                Text(
                  "تعذّر تحميل محطات الراديو.\nيرجى التحقق من اتصالك بالإنترنت أو المحاولة لاحقًا.",
                  style: AppStyles.bold16White,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      data: (radios) {
        return ListView.separated(
          padding: EdgeInsets.only(bottom: 100.h),
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
          itemCount: radios.length,
          itemBuilder: (context, index) {
            final radio = radios[index];
            final isThisRadio = playerState.url == radio.url;
            final isPlayingThis =
                isThisRadio && playerState.status == PlayerStatus.playing;

            return Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  image: AssetImage(
                    isPlayingThis
                        ? AppImage.soundWaveImage
                        : AppImage.mosqueImage,
                  ),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Column(
                  children: [
                    AutoSizeText(
                      radio.name ?? '',
                      style: AppStyles.bold16Black.copyWith(fontSize: 20.sp),
                      minFontSize: 18,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (isPlayingThis) {
                              player.pause();
                            } else {
                              player.playOrToggleRadio(
                                radio.url ?? '',
                                radio.name ?? '',
                              );
                            }
                          },
                          icon: FaIcon(
                            isPlayingThis
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            color: AppColors.blackColor,
                            size: 24.sp,
                          ),
                        ),
                        IconButton(
                          onPressed: player.toggleMute,
                          icon: FaIcon(
                            playerState.isMuted
                                ? FontAwesomeIcons.volumeXmark
                                : FontAwesomeIcons.volumeHigh,
                            color: AppColors.blackColor,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
