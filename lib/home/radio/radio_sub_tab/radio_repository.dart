import 'package:islami_app_demo/services/api/api_manager.dart';
import 'package:islami_app_demo/services/api/end_points.dart';
import 'package:islami_app_demo/services/hive_helper/hive_helpers.dart';
import 'package:islami_app_demo/model/RadioResponseModel.dart';

class RadioRepository {
  static Future<List<RadiosModel>> fetchRadios() async {
    final box = await getRadiosBox();

    // 1) Load from cache first
    if (box.isNotEmpty) {
      print("✅ Loaded ${box.length} radios from Hive cache");
      return box.values.toList();
    }

    // 2) Fetch from API if cache empty
    print("🌐 Fetching radios from API...");
    final json = await ApiManager.getData(
      endPoint: EndPoints.radioEndPoint,
      key: 'language',
      value: 'ar',
    );

    final radioResponse = RadioResponseModel.fromJson(json);
    final radios = radioResponse.radios ?? [];

    // 3) Save to cache
    for (final radio in radios) {
      await box.put(radio.id, radio);
    }

    print("💾 Saved ${radios.length} radios to Hive cache");
    return radios;
  }
}
