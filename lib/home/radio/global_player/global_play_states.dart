import 'package:flutter/foundation.dart';

enum PlayerSourceType { reciter, radio }
enum PlayerStatus { idle, loading, playing, paused, stopped }

@immutable
class GlobalPlayerState {
  final PlayerSourceType? sourceType;
  final String? title;     // surah or radio name
  final String? subtitle;  // reciter name or live stream label
  final String? url;
  final PlayerStatus status;
  final Duration duration;
  final Duration position;
  final bool isMuted;

  const GlobalPlayerState({
    this.sourceType,
    this.title,
    this.subtitle,
    this.url,
    this.status = PlayerStatus.idle,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.isMuted = false,
  });

  GlobalPlayerState copyWith({
    PlayerSourceType? sourceType,
    String? title,
    String? subtitle,
    String? url,
    PlayerStatus? status,
    Duration? duration,
    Duration? position,
    bool? isMuted,
  }) {
    return GlobalPlayerState(
      sourceType: sourceType ?? this.sourceType,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      url: url ?? this.url,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
