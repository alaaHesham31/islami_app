// improved_global_player_notifier.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islami_app_demo/home/radio/global_player/global_play_states.dart';
import 'package:just_audio/just_audio.dart';

class GlobalPlayerNotifier extends StateNotifier<GlobalPlayerState> {
  GlobalPlayerNotifier() : super(const GlobalPlayerState()) {
    // Throttled duration updates
    _durationSub = _player.durationStream.listen((d) {
      if (d != null) state = state.copyWith(duration: d);
    });

    // position: only update once per second to avoid rebuild spam
    _positionSub = _player.positionStream
        .map((p) => Duration(seconds: p.inSeconds)) // map to second precision
        .distinct() // ignore duplicates
        .listen((p) {
      if (state.status != PlayerStatus.idle &&
          state.sourceType == PlayerSourceType.reciter) {
        state = state.copyWith(position: p);
      }
    });

    // player state mapping
    _playerStateSub = _player.playerStateStream.listen((ps) {
      final proc = ps.processingState;
      if (proc == ProcessingState.loading || proc == ProcessingState.buffering) {
        state = state.copyWith(status: PlayerStatus.loading);
      } else if (proc == ProcessingState.completed) {
        state = state.copyWith(status: PlayerStatus.stopped);
      } else {
        state = state.copyWith(status: ps.playing ? PlayerStatus.playing : PlayerStatus.paused);
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  // Use request id to avoid race between rapid play calls
  int _playRequestId = 0;

  Future<void> playOrToggleReciter(String url, String surahName, String reciterName) async {
    // toggle behavior: if same URL and playing -> pause; if same and paused -> resume
    if (state.url == url) {
      if (state.status == PlayerStatus.playing) {
        await pause();
      } else {
        await resume();
      }
      return;
    }
    // else play new
    await _playReciterInternal(url, surahName, reciterName);
  }

  Future<void> _playReciterInternal(String url, String surahName, String reciterName) async {
    final int reqId = ++_playRequestId;
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

      await _player.setUrl(url); // may take time / throw
      // if a newer play request started while we awaited, abort
      if (reqId != _playRequestId) return;
      await _player.play();
    } catch (e) {
      // reset on error
      state = const GlobalPlayerState();
      print("Error playing reciter: $e");
    }
  }

  Future<void> playOrToggleRadio(String url, String radioName) async {
    if (state.url == url) {
      if (state.status == PlayerStatus.playing) {
        await pause();
      } else {
        await resume();
      }
      return;
    }
    await _playRadioInternal(url, radioName);
  }

  Future<void> _playRadioInternal(String url, String radioName) async {
    final int reqId = ++_playRequestId;
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
      if (reqId != _playRequestId) return;
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

  // mute/unmute with storing last volume
  double _lastVolume = 1.0;
  Future<void> toggleMute() async {
    final newMuted = !state.isMuted;
    if (newMuted) {
      // store current volume before muting
      try {
        _lastVolume = await _player.volume; // volume getter from just_audio
      } catch (_) {
        _lastVolume = 1.0;
      }
      await _player.setVolume(0.0);
      state = state.copyWith(isMuted: true);
    } else {
      await _player.setVolume(_lastVolume);
      state = state.copyWith(isMuted: false);
    }
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
