import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:islami_app_demo/api/api_constants.dart';
import 'package:islami_app_demo/api/end_points.dart';
import 'package:islami_app_demo/home/radio/reciter_sub_tab/hive_helpers.dart';
import 'package:islami_app_demo/model/ReciterModel.dart';
import 'package:islami_app_demo/model/SuraModel.dart';

class ReciterRepository {
  static Future<List<SuraModel>> loadSurahsNames() async {
    final jsonString = await rootBundle.loadString(
      'assets/files/surah_names.json',
    );
    final List decoded = jsonDecode(jsonString);

    return decoded.map((sura) => SuraModel.fromJson(sura)).toList();
  }


static Future<List<ReciterModel>> loadAllRecitersNames() async {
  final box = await getRecitersBox(); // Box<ReciterModel>

  // 1) Check cache first
  if (box.isNotEmpty) {
    print("✅ Loaded ${box.length} reciters from Hive cache");
    return box.values.toList();
  }

  // 2) No cache → fetch from API
  print("🌐 Fetching reciters from API...");
  final uri = Uri.https(ApiConstants.baseUrl, EndPoints.recitersEndPoint, {
    'language': 'ar',
  });

  final resp = await http.get(uri);
  if (resp.statusCode != 200) {
    throw Exception('Failed to fetch reciters (${resp.statusCode})');
  }

  final body = jsonDecode(resp.body) as Map<String, dynamic>;
  final recitersJson = body['reciters'] as List<dynamic>? ?? [];

  final reciters = recitersJson
      .map((e) => ReciterModel.fromJson(Map<String, dynamic>.from(e)))
      .toList();

  // Save each reciter in cache (key = id)
  for (final r in reciters) {
    await box.put(r.id, r);
  }

  print("💾 Saved ${reciters.length} reciters to Hive cache");
  return reciters;
}


}


  

