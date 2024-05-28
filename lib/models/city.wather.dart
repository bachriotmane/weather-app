// ignore_for_file: public_member_api_docs, sort_constructors_first
class CityWeather {
  String cityName;
  double lat;
  double ampl;
  String weatherStatus;
  double minTemp;
  double maxTemp;
  String dayName;
  CityWeather({
    this.dayName = "",
    required this.cityName,
    required this.lat,
    required this.ampl,
    required this.weatherStatus,
    required this.minTemp,
    required this.maxTemp,
  });
}
