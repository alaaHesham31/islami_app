import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:islami_app_demo/model/DownloadedSurahModel.dart';
import 'package:islami_app_demo/model/RadioResponseModel.dart'
    show RadiosModel, RadiosModelAdapter;

import '../../../model/ReciterModel.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ReciterModelAdapter());
  Hive.registerAdapter(MoshafModelAdapter());
  Hive.registerAdapter(RadiosModelAdapter());
  Hive.registerAdapter(DownloadedSurahAdapter());

  final legacyReciters = await _extractLegacyRecitersIfAny();
  final legacyRadios = await _extractLegacyRadiosIfAny();

  final recitersBox = await Hive.openBox<ReciterModel>('recitersBox');
  final radiosBox = await Hive.openBox<RadiosModel>('radiosBox');
  if (legacyReciters.isNotEmpty) {
    for (final r in legacyReciters) {
      await recitersBox.put(r.id, r);
    }
  }

  if (legacyRadios.isNotEmpty) {
    for (final radio in legacyRadios) {
      await radiosBox.put(radio.id, radio);
    }
  }

  await Hive.openBox<DownloadedSurah>('downloadsBox');
}

Future<List<ReciterModel>> _extractLegacyRecitersIfAny() async {
  const boxName = 'recitersBox';
  final rawBox = await Hive.openBox(boxName);
  final List<ReciterModel> extracted = [];

  if (rawBox.isEmpty) {
    await rawBox.close();
    return extracted;
  }

  if (rawBox.containsKey('reciters')) {
    final value = rawBox.get('reciters');
    if (value is List) {
      for (final item in value) {
        if (item is ReciterModel) {
          extracted.add(item);
        } else if (item is Map) {
          extracted.add(ReciterModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
  } else {
    for (final value in rawBox.values) {
      if (value is ReciterModel) {
        extracted.add(value);
      } else if (value is Map) {
        extracted.add(ReciterModel.fromJson(Map<String, dynamic>.from(value)));
      } else if (value is List) {
        for (final item in value) {
          if (item is Map) {
            extracted.add(
              ReciterModel.fromJson(Map<String, dynamic>.from(item)),
            );
          } else if (item is ReciterModel) {
            extracted.add(item);
          }
        }
      }
    }
  }

  await rawBox.clear();
  await rawBox.close();
  return extracted;
}

Future<List<RadiosModel>> _extractLegacyRadiosIfAny() async {
  const boxName = 'radiosBox';
  final rawBox = await Hive.openBox(boxName);
  final List<RadiosModel> extracted = [];

  if (rawBox.isEmpty) {
    await rawBox.close();
    return extracted;
  }

  if (rawBox.containsKey('radios')) {
    final value = rawBox.get('radios');
    if (value is List) {
      for (final item in value) {
        if (item is RadiosModel) {
          extracted.add(item);
        } else if (item is Map) {
          extracted.add(RadiosModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
  } else {
    for (final value in rawBox.values) {
      if (value is RadiosModel) {
        extracted.add(value);
      } else if (value is Map) {
        extracted.add(RadiosModel.fromJson(Map<String, dynamic>.from(value)));
      } else if (value is List) {
        for (final item in value) {
          if (item is Map) {
            extracted.add(
              RadiosModel.fromJson(Map<String, dynamic>.from(item)),
            );
          } else if (item is RadiosModel) {
            extracted.add(item);
          }
        }
      }
    }
  }

  await rawBox.clear();
  await rawBox.close();
  return extracted;
}
