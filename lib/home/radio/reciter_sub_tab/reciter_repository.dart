import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:islami_app_demo/api/api_constants.dart';
import 'package:islami_app_demo/api/end_points.dart';
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

  // load all reciters name

  static Future<List<ReciterModel>> loadAllRecitersNames() async {
    try {
      Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.recitersEndPoint, {
        "language": "ar",
      });
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final recitersJson = json['reciters'] as List;

        return recitersJson
            .map((reciter) => ReciterModel.fromJson(reciter))
            .toList();
      } else {
        throw Exception("Failed to fetch reciters");
      }
    } catch (e) {
      rethrow;
    }
  }
}

