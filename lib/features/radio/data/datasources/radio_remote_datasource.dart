import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/radio.dart';
import '../../../../services/api/api_constants.dart';
import '../../../../services/api/end_points.dart';

class RadioRemoteDataSource {
  Future<List<RadioEntity>> fetchRadios() async {
    final url = Uri.https(ApiConstants.baseUrl, EndPoints.radioEndPoint, {'language': 'ar'});
    final response = await http.get(url);
    final json = jsonDecode(response.body);

    final list = (json['radios'] as List<dynamic>? ?? []);
    return list.map((e) => RadioEntity(
      id: e['id'],
      name: e['name'],
      url: e['url'],
      recentDate: e['recent_date'],
    )).toList();
  }
}
