import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.mainCondition,
    required super.temperature,
    required super.conditionCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String cityName) {
    return WeatherModel(
      cityName: cityName,
      temperature: json['current']['temperature_2m'].toDouble(),
      mainCondition: _mapCodeToCondition(json['current']['weather_code']),
      conditionCode: json['current']['weather_code'],
    );
  }

  static String _mapCodeToCondition(int code) {
    if (code == 0) return 'Clear';
    if (code < 40) return 'Cloudy';
    if (code < 70) return 'Rain';
    return 'Storm';
  }
}