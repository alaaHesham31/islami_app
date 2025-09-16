import 'package:flutter/services.dart';
import '../models/hadeath_model.dart';

class HadeathLocalDataSource {
  Future<List<HadeathModel>> loadAhadeeth() async {
    List<HadeathModel> list = [];
    for (int i = 1; i <= 50; i++) {
      final content = await rootBundle.loadString('assets/files/hadeath/h$i.txt');
      list.add(HadeathModel.fromFileContent(content));
    }
    return list;
  }
}
