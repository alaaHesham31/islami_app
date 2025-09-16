import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islami_app_demo/features/download/data/models/DownloadedSurahModel.dart';

import '../../../../home/radio/global_player/global_play_states.dart';
import '../../../../home/radio/global_player/global_player_notifier.dart';
import '../../../../home/radio/global_player/mini_player.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_styles.dart';
import '../../../download/presentation/download_providers.dart';

import '../../../reciters/domain/entities/reciter.dart';
import '../providers/reciters_provider.dart';

class ReciterSurahListScreen extends ConsumerWidget {
  static const String routeName = 'reciter_sura_list_names';
  final Reciter reciter;

  const ReciterSurahListScreen({super.key, required this.reciter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSurahs = ref.watch(getSurahsNamesProvider);
    final playerState = ref.watch(globalPlayerProvider);
    final player = ref.read(globalPlayerProvider.notifier);

    final downloadManager = ref.read(downloadServiceProvider);

    final moshaf = reciter.moshaf.isNotEmpty ? reciter.moshaf.first : null;

    return asyncSurahs.when(
      data: (surahs) {
        if (surahs.isEmpty || moshaf == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(reciter.name, style: AppStyles.bold16White),
              centerTitle: true,
            ),
            body: Center(
              child: Text(
                "لا توجد سور متاحة لهذا المقرئ",
                style: AppStyles.bold16White,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(reciter.name, style: AppStyles.bold16White),
            centerTitle: true,
            backgroundColor: AppColors.blackColor,
          ),
          body: Container(
            padding: EdgeInsets.all(16.w),
            color: AppColors.blackColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: surahs.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final surah = surahs[index];
                      final surahNumber = surah.id.toString().padLeft(3, '0');
                      final url = "${moshaf.server}$surahNumber.mp3";
                      final key = '${moshaf.id}_${surah.id}';

                      final isThisPlaying =
                          playerState.url == url &&
                          playerState.status == PlayerStatus.playing;

                      return Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                surah.arabicName ,
                                style: AppStyles.bold16Black,
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, _) {
                                final progress = ref.watch(
                                  downloadProgressProvider(key),
                                );
                                final downloadedMapAsync = ref.watch(
                                  downloadedSurahsProvider,
                                );
                                final downloadedMap = downloadedMapAsync
                                    .maybeWhen(
                                      data: (m) => m,
                                      orElse:
                                          () =>
                                              <String, DownloadedSurahModel>{},
                                    );
                                final isDownloaded =
                                    downloadedMap[key]?.isDownloaded ?? false;

                                if (progress != null &&
                                    progress >= 0.0 &&
                                    progress < 1.0) {
                                  return SizedBox(
                                    width: 40.w,
                                    height: 40.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: progress,
                                          strokeWidth: 2.r,
                                          color: AppColors.blackColor,
                                        ),
                                        Text(
                                          '${(progress * 100).toInt()}%',
                                          style: AppStyles.semi16Black,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (isDownloaded) {
                                  return const Icon(
                                    Icons.check_circle,
                                    color: AppColors.blackColorBg,
                                  );
                                }
                                return IconButton(
                                  onPressed: () async {
                                    try {
                                      await downloadManager.downloadSurah(
                                        reciterId: moshaf.id,
                                        surahId: surah.id.toInt(),
                                        remoteUrl: url,
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "📥 تم تحميل سورة ${surah.arabicName} بنجاح",
                                          ),
                                        ),
                                      );

                                      ref.refresh(downloadedSurahsProvider);
                                    } catch (_) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "فشل التحميل: تحقق من اتصال الإنترنت",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Image.asset(
                                    AppImage.downloadIcon,
                                    height: 20.h,
                                  ),
                                );
                              },
                            ),

                            SizedBox(width: 8.w),

                            IconButton(
                              onPressed: () async {
                                final File? file = await downloadManager
                                    .getLocalFile(moshaf.id, surah.id.toInt());

                                if (file != null) {
                                  player.playOrToggleReciter(
                                    file.path,
                                    '',
                                    reciter.name ,
                                    isLocal: true,
                                  );
                                } else {
                                  player.playOrToggleReciter(
                                    url,
                                    '',
                                    reciter.name ,
                                    isLocal: false,
                                  );
                                }
                              },
                              icon:
                                  isThisPlaying
                                      ? FaIcon(
                                        FontAwesomeIcons.pause,
                                        color: AppColors.blackColor,
                                        size: 20.sp,
                                      )
                                      : FaIcon(
                                        FontAwesomeIcons.play,
                                        color: AppColors.blackColor,
                                        size: 20.sp,
                                      ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const MiniPlayer(),
              ],
            ),
          ),
        );
      },
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
      error:
          (_, __) => Center(
            child: Text(
              "تعذر تحميل السور\nيرجى المحاولة لاحقًا",
              textAlign: TextAlign.center,
              style: AppStyles.bold16White,
            ),
          ),
    );
  }
}
