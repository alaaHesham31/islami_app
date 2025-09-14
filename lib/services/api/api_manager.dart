import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:islami_app_demo/services/api/api_constants.dart';

class ApiManager {
  // get data
 static Future<dynamic> getData({
    required String endPoint,
    required String key,
    required String value,
  }) async {
    Uri url = Uri.https(ApiConstants.baseUrl, endPoint, {key: value});
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    return json;
  }
}
