import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islami_app_demo/model/AzkarModel.dart';

class AzkarRepository {
  static Future<Map<String, List<AzkarModel>>> loadAzkarFiles() async {
    try {
      final String response = await rootBundle.loadString('assets/files/azkar.json');
      final data = jsonDecode(response) as Map<String, dynamic>;

      return data.map((key, value) {
        final list = (value as List)
            .map((item) => AzkarModel.fromJson(item))
            .toList();
        return MapEntry(key, list);
      });
    } catch (e) {
      print("Error loading or decoding JSON: $e");
      rethrow;
    }
  }
}
