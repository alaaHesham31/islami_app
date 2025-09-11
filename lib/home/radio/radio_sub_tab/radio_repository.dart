
import 'package:islami_app_demo/api/api_manager.dart';
import 'package:islami_app_demo/api/end_points.dart';
import 'package:islami_app_demo/model/RadioResponseModel.dart';

// data source impl
class RadioRepository {
  static Future<List<RadiosModel>> fetchRadios() async {
    try {
      var json = await ApiManager.getData(
        endPoint: EndPoints.radioEndPoint,
        key: 'language',
        value: 'ar',
      );
      final radioResponse = RadioResponseModel.fromJson(json);
      return radioResponse.radios!
          .map((radio) => RadiosModel(name: radio.name, url: radio.url))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  //   try {
  //     Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.radioEndPoint, {
  //       'language': 'ar',
  //     });
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       final radioResponse = RadioResponseModel.fromJson(json);
  //       return radioResponse.radios!
  //           .map((radio) => RadiosModel(name: radio.name, url: radio.url))
  //           .toList();
  //     } else {
  //       throw Exception("Failed to fetch radios");
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
