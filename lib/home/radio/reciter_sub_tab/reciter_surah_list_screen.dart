import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:islami_app_demo/home/radio/global_player/global_play_states.dart';
import 'package:islami_app_demo/home/radio/global_player/mini_player.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_provider.dart';
import 'package:islami_app_demo/home/radio/global_player/global_player_notifier.dart';
import 'package:islami_app_demo/model/DownloadedSurahModel.dart';
import 'package:islami_app_demo/services/download/download_progress_manager.dart';
import 'package:islami_app_demo/services/download/download_service%20.dart'
    show DownloadService;
import 'package:islami_app_demo/services/hive_helper/hive_helpers.dart'
    show getDownloadsBox;
import 'package:islami_app_demo/model/ReciterModel.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_styles.dart';

class ReciterSurahListScreen extends ConsumerWidget {
  static const String routeName = 'reciter-surah-list_screen';

  const ReciterSurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suraNamesAsync = ref.watch(surahNamesListProvider);
    final playerState = ref.watch(globalPlayerProvider);
    final player = ref.read(globalPlayerProvider.notifier);

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final reciterName = args['name'] as String;
    final moshaf = args['moshaf'] as MoshafModel;

    return suraNamesAsync.when(
      error: (error, stack) => Text('Error: $error'),
      loading:
          () => Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
      data: (sura) {
        return Scaffold(
          appBar: AppBar(
            title: Text(reciterName, style: AppStyles.bold16Primary),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: AppColors.blackColor),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: sura.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final suraItem = sura[index];
                      final surahNumber = suraItem.id.toString().padLeft(
                        3,
                        '0',
                      );
                      final url = "${moshaf.server}$surahNumber.mp3";

                      final isThisPlaying =
                          playerState.url == url &&
                          playerState.status == PlayerStatus.playing;

                      final key = '${moshaf.id}_${suraItem.id}';

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text(
                              suraItem.arabicName ?? '',
                              style: AppStyles.semi16Black,
                            ),
                            const Spacer(),
                            downloadButton(
                              key: key,
                              moshaf: moshaf,
                              suraItem: suraItem,
                              url: url,
                              context: context,
                            ),
                            playButton(
                              key: key,
                              suraItem: suraItem,
                              reciterName: reciterName,
                              url: url,
                              isThisPlaying: isThisPlaying,
                              player: player,
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
    );
  }

  Widget downloadButton({
    required String key,
    required MoshafModel moshaf,
    required dynamic suraItem,
    required String url,
    required BuildContext context,
  }) {
    return ValueListenableBuilder(
      valueListenable: DownloadProgressManager.instance.listenable,
      builder: (context, Map<String, double> progressMap, _) {
        final progress = progressMap[key];
        if (progress != null && progress >= 0.0 && progress < 1.0) {
          return SizedBox(
            width: 36,
            height: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(value: progress, strokeWidth: 2, color: AppColors.blackColor,),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        }

        // check Hive if already downloaded
        final downloadsBox =
            Hive.isBoxOpen('downloadsBox')
                ? Hive.box<DownloadedSurah>('downloadsBox')
                : null;
        final downloaded =
            downloadsBox != null && downloadsBox.containsKey(key);

        if (downloaded) {
          return Icon(Icons.check_circle, color: AppColors.blackColor, size: 22);
        }

        return IconButton(
          onPressed: () async {
            try {
              await DownloadService().downloadSurah(
                reciterId: moshaf.id,
                surahId: suraItem.id as int,
                remoteUrl: url,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("📥 تم تحميل سورة ${suraItem.arabicName} بنجاح"),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("فشل التحميل: تحقق من اتصال الإنترنت"),
                ),
              );
            }
          },
          icon: Image.asset(AppImage.downloadIcon, height: 20),
        );
      },
    );
  }

  Widget playButton({
    required String key,
    required dynamic suraItem,
    required String reciterName,
    required String url,
    required bool isThisPlaying,
    required GlobalPlayerNotifier player,
  }) {
    return IconButton(
      onPressed: () async {
        final box =
            Hive.isBoxOpen('downloadsBox')
                ? Hive.box<DownloadedSurah>('downloadsBox')
                : await getDownloadsBox();
        final model = box.get(key);
        if (model != null) {
          final file = File(model.localPath);
          if (await file.exists()) {
            player.playOrToggleReciter(
              model.localPath,
              suraItem.arabicName ?? '',
              reciterName,
              isLocal: true,
            );
            return;
          } else {
            await box.delete(key); // cleanup missing file
          }
        }
        // fallback to remote
        player.playOrToggleReciter(
          url,
          suraItem.arabicName ?? '',
          reciterName,
          isLocal: false,
        );
      },
      icon:
          isThisPlaying
              ? FaIcon(
                FontAwesomeIcons.pause,
                color: AppColors.blackColor,
                size: 20,
              )
              : FaIcon(
                FontAwesomeIcons.play,
                color: AppColors.blackColor,
                size: 20,
              ),
    );
  }
}
