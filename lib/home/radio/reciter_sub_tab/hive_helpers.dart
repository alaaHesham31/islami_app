// lib/home/radio/reciter_sub_tab/hive_helpers.dart
import 'package:hive/hive.dart';
import 'package:islami_app_demo/model/ReciterModel.dart';

const String recitersBoxName = 'recitersBox';

Future<Box<ReciterModel>> getRecitersBox() async {
  if (Hive.isBoxOpen(recitersBoxName)) {
    return Hive.box<ReciterModel>(recitersBoxName);
  }
  return await Hive.openBox<ReciterModel>(recitersBoxName);
}
