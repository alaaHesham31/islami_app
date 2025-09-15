import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerApiService {
  final String base = 'https://api.aladhan.com/v1';

  Future<Map<String, DateTime>> fetchPrayerTimes(
    double lat,
    double lng,
    DateTime date,
  ) async {
    final timestamp =
        (DateTime(date.year, date.month, date.day).millisecondsSinceEpoch ~/
            1000);
    final url = Uri.parse(
      '$base/timings/$timestamp?latitude=$lat&longitude=$lng&method=2',
    );
    final resp = await http.get(url);
    if (resp.statusCode != 200)
      throw Exception('Failed to fetch times: ${resp.statusCode}');
    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final timings = (data['timings'] as Map<String, dynamic>);

    DateTime parseTime(String hhmm) {
      final cleaned = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(hhmm);
      if (cleaned == null)
        throw Exception('Invalid time format from API: $hhmm');
      final hour = int.parse(cleaned.group(1)!);
      final minute = int.parse(cleaned.group(2)!);
      return DateTime(date.year, date.month, date.day, hour, minute);
    }

    final map = <String, DateTime>{};
    for (final k in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
      if (timings.containsKey(k)) {
        map[k] = parseTime(timings[k].toString());
      }
    }
    return map;
  }
}
