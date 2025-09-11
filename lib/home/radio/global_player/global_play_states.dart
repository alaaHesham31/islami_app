// lib/home/radio/global_player_state.dart
import 'package:flutter/foundation.dart';

enum PlayerSourceType { reciter, radio }
enum PlayerStatus { idle, loading, playing, paused, stopped }

@immutable
class GlobalPlayerState {
  final PlayerSourceType? sourceType; // reciter or radio
  final String? title; // surah name or radio station
  final String? subtitle; // reciter name or "Live Stream"
  final String? url;
  final PlayerStatus status;
  final Duration position;
  final Duration duration;
  final bool isMuted;

  const GlobalPlayerState({
    this.sourceType,
    this.title,
    this.subtitle,
    this.url,
    this.status = PlayerStatus.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isMuted = false,
  });

  GlobalPlayerState copyWith({
    PlayerSourceType? sourceType,
    String? title,
    String? subtitle,
    String? url,
    PlayerStatus? status,
    Duration? position,
    Duration? duration,
    bool? isMuted,
  }) {
    return GlobalPlayerState(
      sourceType: sourceType ?? this.sourceType,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      url: url ?? this.url,
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
