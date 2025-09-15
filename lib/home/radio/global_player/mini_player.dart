import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islami_app_demo/home/radio/global_player/global_play_states.dart'
    show PlayerSourceType, PlayerStatus;
import 'package:islami_app_demo/home/radio/global_player/global_player_notifier.dart';


import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(globalPlayerProvider);
    final player = ref.read(globalPlayerProvider.notifier);

    if (playerState.status == PlayerStatus.stopped || playerState.url == null) {
      return const SizedBox.shrink();
    }

    final duration = playerState.duration ?? Duration.zero;
    final position = playerState.position ?? Duration.zero;
    final durationSeconds = duration.inSeconds.toDouble().clamp(
      0.0,
      double.infinity,
    );
    final positionSeconds = position.inSeconds.toDouble().clamp(
      0.0,
      durationSeconds,
    );

    if (playerState.errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        color: Colors.redAccent,
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                playerState.errorMessage!,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                ref.read(globalPlayerProvider.notifier).stop();
              },
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title + Subtitle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerState.title ?? '',
                      style: AppStyles.bold16Primary.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (playerState.subtitle != null)
                      Text(
                        playerState.subtitle!,
                        style: AppStyles.semi16White.copyWith(
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              if (playerState.status == PlayerStatus.loading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    if (playerState.status == PlayerStatus.playing) {
                      player.pause();
                    } else {
                      player.resume();
                    }
                  },
                  icon: FaIcon(
                    playerState.status == PlayerStatus.playing
                        ? FontAwesomeIcons.pause
                        : FontAwesomeIcons.play,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              IconButton(
                onPressed: () => player.stop(),
                icon: const FaIcon(
                  FontAwesomeIcons.stop,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          // ✅ Show progress bar only for Surah playback
          if (playerState.sourceType == PlayerSourceType.reciter &&
              durationSeconds > 0)
            Row(
              children: [
                Text(
                  _formatDuration(position),
                  style: AppStyles.semi16Black.copyWith(color: Colors.white),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: durationSeconds,
                      value: positionSeconds,
                      onChanged: (v) {
                        player.seek(Duration(seconds: v.toInt()));
                      },
                      activeColor: AppColors.primaryColor,
                      inactiveColor: Colors.white24,
                    ),
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: AppStyles.semi16Black.copyWith(color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }
}
