import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:islami_app_demo/services/api/api_constants.dart';
import 'package:islami_app_demo/services/api/end_points.dart';
import 'package:islami_app_demo/services/hive_helper/hive_helpers.dart';
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
  final box = await getRecitersBox(); 

  // 1) Check cache first
  if (box.isNotEmpty) {
    debugPrint(" Loaded ${box.length} reciters from Hive cache");
    return box.values.toList();
  }

  // 2) No cache → fetch from API
  debugPrint(" Fetching reciters from API...");
  final uri = Uri.https(ApiConstants.baseUrl, EndPoints.recitersEndPoint, {
    'language': 'ar',
  });

  final response = await http.get(uri);
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch reciters (${response.statusCode})');
  }

  final body = jsonDecode(response.body) as Map<String, dynamic>;
  final recitersJson = body['reciters'] as List<dynamic>? ?? [];

  final reciters = recitersJson
      .map((e) => ReciterModel.fromJson(Map<String, dynamic>.from(e)))
      .toList();

  // Save each reciter in cache (key = id)
  for (final reciter in reciters) {
    await box.put(reciter.id, reciter);
  }

  debugPrint(" Saved ${reciters.length} reciters to Hive cache");
  return reciters;
}


}


  

