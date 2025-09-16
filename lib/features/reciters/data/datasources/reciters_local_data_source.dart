import 'package:hive/hive.dart';
import '../models/reciter_model.dart';

class RecitersLocalDataSource {
  static const String boxName = 'recitersBox';

  Future<List<ReciterModel>> getCachedReciters() async {
    final box = await Hive.openBox<ReciterModel>(boxName);
    return box.values.toList();
  }

  Future<void> cacheReciters(List<ReciterModel> reciters) async {
    final box = await Hive.openBox<ReciterModel>(boxName);
    for (final reciter in reciters) {
      await box.put(reciter.reciterId, reciter);
    }
  }
}
