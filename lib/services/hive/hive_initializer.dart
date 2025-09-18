import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../features/download/data/models/DownloadedSurahModel.dart';
import '../../features/radio/domain/entities/radio.dart';
import '../../features/reciters/data/models/moshaf_model.dart';
import '../../features/reciters/data/models/reciter_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ReciterModelAdapter());
  Hive.registerAdapter(MoshafModelAdapter());
  Hive.registerAdapter(RadioEntityAdapter());
  Hive.registerAdapter(DownloadedSurahAdapter());

  await Hive.openBox<DownloadedSurahModel>('downloadsBox');
}


