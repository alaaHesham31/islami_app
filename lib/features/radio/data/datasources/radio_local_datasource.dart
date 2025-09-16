import 'package:hive/hive.dart';
import '../../domain/entities/radio.dart';

const String radiosBoxName = 'radiosBox';

class RadioLocalDataSource {
  Future<Box<RadioEntity>> _openBox() async {
    if (!Hive.isBoxOpen(radiosBoxName)) {
      return await Hive.openBox<RadioEntity>(radiosBoxName);
    }
    return Hive.box<RadioEntity>(radiosBoxName);
  }

  Future<List<RadioEntity>> getCachedRadios() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> cacheRadios(List<RadioEntity> radios) async {
    final box = await _openBox();
    for (final radio in radios) {
      await box.put(radio.id, radio);
    }
  }
}
