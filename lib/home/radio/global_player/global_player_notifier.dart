// lib/home/radio/global_player_notifier.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/home/radio/global_player/global_play_states.dart';
import 'package:just_audio/just_audio.dart';

class GlobalPlayerNotifier extends StateNotifier<GlobalPlayerState> {
  GlobalPlayerNotifier() : super(const GlobalPlayerState()) {
    _durationSub = _player.durationStream.listen((d) {
      if (d != null) {
        state = state.copyWith(duration: d);
      }
    });

    _positionSub = _player.positionStream.listen((p) {
      if (state.status != PlayerStatus.idle &&
          state.sourceType == PlayerSourceType.reciter) {
        state = state.copyWith(position: p);
      }
    });

    _playerStateSub = _player.playerStateStream.listen((ps) {
      if (ps.processingState == ProcessingState.loading ||
          ps.processingState == ProcessingState.buffering) {
        state = state.copyWith(status: PlayerStatus.loading);
      } else if (ps.processingState == ProcessingState.completed) {
        state = state.copyWith(status: PlayerStatus.stopped);
      } else {
        state = state.copyWith(
          status: ps.playing ? PlayerStatus.playing : PlayerStatus.paused,
        );
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  // --- Play a Surah
  Future<void> playReciter(
      String url, String surahName, String reciterName) async {
    try {
      await _player.stop();
      state = state.copyWith(
        sourceType: PlayerSourceType.reciter,
        title: surahName,
        subtitle: reciterName,
        url: url,
        status: PlayerStatus.loading,
        position: Duration.zero,
        duration: Duration.zero,
      );
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      state = const GlobalPlayerState();
      print("Error playing reciter: $e");
    }
  }

  // --- Play a Radio
  Future<void> playRadio(String url, String radioName) async {
    try {
      await _player.stop();
      state = state.copyWith(
        sourceType: PlayerSourceType.radio,
        title: radioName,
        subtitle: "Radio Quran",
        url: url,
        status: PlayerStatus.loading,
        position: Duration.zero,
        duration: Duration.zero,
      );
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      state = const GlobalPlayerState();
      print("Error playing radio: $e");
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
    state = const GlobalPlayerState();
  }

  Future<void> seek(Duration pos) async {
    await _player.seek(pos);
    state = state.copyWith(position: pos);
  }

  Future<void> toggleMute() async {
    final newMuted = !state.isMuted;
    await _player.setVolume(newMuted ? 0 : 1);
    state = state.copyWith(isMuted: newMuted);
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final globalPlayerProvider =
StateNotifierProvider<GlobalPlayerNotifier, GlobalPlayerState>(
      (ref) => GlobalPlayerNotifier(),
);
