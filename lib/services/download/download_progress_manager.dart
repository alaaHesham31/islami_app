import 'package:flutter/foundation.dart';

class DownloadProgressManager {
  DownloadProgressManager._internal();
  static final DownloadProgressManager instance = DownloadProgressManager._internal();

  final ValueNotifier<Map<String, double>> _notifier = ValueNotifier({});

  ValueListenable<Map<String, double>> get listenable => _notifier;

  void setProgress(String key, double progress) {
    final copy = Map<String, double>.from(_notifier.value);
    copy[key] = progress;
    _notifier.value = copy;
  }

  double? getProgress(String key) => _notifier.value[key];
}
