import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islami_app_demo/home/radio/global_player/global_play_states.dart';
import 'package:islami_app_demo/home/radio/global_player/mini_player.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/reciter_provider.dart';
import 'package:islami_app_demo/home/radio/global_player/global_player_notifier.dart';
import 'package:islami_app_demo/theme/app_colors.dart' show AppColors;
import 'package:islami_app_demo/theme/app_image.dart';
import 'package:islami_app_demo/theme/app_styles.dart';
import 'package:islami_app_demo/model/ReciterModel.dart';

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
      loading: () => Center(
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
                      final surahNumber =
                      suraItem.id.toString().padLeft(3, '0');
                      final url = "${moshaf.server}$surahNumber.mp3";

                      final isThisPlaying = playerState.url == url &&
                          playerState.status == PlayerStatus.playing;

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
                            IconButton(
                              onPressed: () {},
                              icon: Image(
                                image: AssetImage(AppImage.downloadIcon),
                                height: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (isThisPlaying) {
                                  player.pause();
                                } else {
                                  player.playReciter(
                                    url,
                                    suraItem.arabicName ?? '',
                                    reciterName,
                                  );
                                }
                              },
                              icon: isThisPlaying
                                  ? const FaIcon(FontAwesomeIcons.pause,
                                  color: AppColors.blackColor, size: 20)
                                  : const FaIcon(FontAwesomeIcons.play,
                                  color: AppColors.blackColor, size: 20),
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
}
