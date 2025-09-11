import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'surah_player_states.dart';

class SurahPlayerNotifier extends StateNotifier<SurahPlayerState> {
  SurahPlayerNotifier() : super(const SurahPlayerState()) {
    // Listen for duration changes
    _durationSub = _player.durationStream.listen((d) {
      if (d != null) {
        state = state.copyWith(duration: d);
      }
    });

    // Listen for playback state changes
    _playerStateSub = _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.buffering ||
          ps.processingState == ProcessingState.loading) {
        state = state.copyWith(status: PlayerStatus.loading);
      } else if (ps.processingState == ProcessingState.completed) {
        // Reset when surah ends
        state = const SurahPlayerState();
      } else {
        state = state.copyWith(
          status: ps.playing ? PlayerStatus.playing : PlayerStatus.paused,
        );
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  AudioPlayer get player => _player; // expose to positionProvider

  Future<void> play(
      String url,
      int surahId,
      String surahName,
      String reciterName,
      ) async {
    try {
      state = state.copyWith(
        currentSurahId: surahId,
        currentSurahName: surahName,
        currentReciterName: reciterName,
        status: PlayerStatus.loading,
      );

      await _player.stop(); // stop any old surah
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      state = const SurahPlayerState();
      print("Error playing audio: $e");
    }
  }

  Future<void> pause() async {
    await _player.pause();
    state = state.copyWith(status: PlayerStatus.paused);
  }

  Future<void> resume() async {
    await _player.play();
    state = state.copyWith(status: PlayerStatus.playing);
  }

  Future<void> stop() async {
    await _player.stop();
    state = const SurahPlayerState();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final surahPlayerProvider =
StateNotifierProvider<SurahPlayerNotifier, SurahPlayerState>(
      (ref) => SurahPlayerNotifier(),
);

// independent stream for fast updates (position)
final positionProvider = StreamProvider<Duration>((ref) {
  final player = ref.watch(surahPlayerProvider.notifier).player;
  return player.positionStream;
});
