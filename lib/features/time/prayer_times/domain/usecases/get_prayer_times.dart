import '../repositories/prayer_repository.dart';


class GetPrayerTimes {
  final PrayerRepository repository;
  GetPrayerTimes(this.repository);


  Future<Map<String, DateTime>> call(double lat, double lng,
      {DateTime? date, bool forceRefresh = false}) async {
    return repository.getPrayerTimes(lat, lng, date: date, forceRefresh: forceRefresh);
  }
}