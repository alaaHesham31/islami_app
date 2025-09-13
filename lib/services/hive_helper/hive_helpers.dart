import 'package:hive/hive.dart';
import 'package:islami_app_demo/model/DownloadedSurahModel.dart' show DownloadedSurah;
import 'package:islami_app_demo/model/RadioResponseModel.dart';
import 'package:islami_app_demo/model/ReciterModel.dart';

const String recitersBoxName = 'recitersBox';

Future<Box<ReciterModel>> getRecitersBox() async {
  if (Hive.isBoxOpen(recitersBoxName)) {
    return Hive.box<ReciterModel>(recitersBoxName);
  }
  return await Hive.openBox<ReciterModel>(recitersBoxName);
}


const String radiosBoxName = 'radiosBox';

Future<Box<RadiosModel>> getRadiosBox() async {
  if (!Hive.isBoxOpen(radiosBoxName)) {
    return await Hive.openBox<RadiosModel>(radiosBoxName);
  }
  return Hive.box<RadiosModel>(radiosBoxName);
}


const String downloadsBoxName = 'downloadsBox';

Future<Box<DownloadedSurah>> getDownloadsBox() async {
  if (!Hive.isBoxOpen(downloadsBoxName)) {
    return await Hive.openBox<DownloadedSurah>(downloadsBoxName);
  }
  return Hive.box<DownloadedSurah>(downloadsBoxName);
}
