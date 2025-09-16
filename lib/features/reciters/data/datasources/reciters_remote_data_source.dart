import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../services/api/api_constants.dart';
import '../../../../services/api/end_points.dart';
import '../models/reciter_model.dart';


class RecitersRemoteDataSource {
  Future<List<ReciterModel>> fetchReciters() async {
    final uri = Uri.https(ApiConstants.baseUrl, EndPoints.recitersEndPoint, {
      'language': 'ar',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('فشل في تحميل القراء');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final recitersJson = body['reciters'] as List<dynamic>? ?? [];

    return recitersJson
        .map((e) => ReciterModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
