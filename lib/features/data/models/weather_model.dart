import 'package:ezze_weather/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.mainCondition,
    required super.temperature,
    required super.conditionCode,
    required super.humidity,
    required super.windSpeed,
    required super.apparentTemperature,
    required super.hourlyForecast,
    required super.dailyForecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String cityName) {
    // Parse Hourly
    List<HourlyForecast> hourly = [];
    if (json['hourly'] != null) {
      final times = json['hourly']['time'] as List;
      final temps = json['hourly']['temperature_2m'] as List;
      final codes = json['hourly']['weather_code'] as List;
      
      // Limit to next 24 hours
      int count = times.length > 24 ? 24 : times.length;
      for (int i = 0; i < count; i++) {
        hourly.add(HourlyForecast(
          time: DateTime.parse(times[i]),
          temperature: temps[i].toDouble(),
          conditionCode: codes[i],
          condition: _mapCodeToCondition(codes[i]),
        ));
      }
    }

    // Parse Daily
    List<DailyForecast> daily = [];
    if (json['daily'] != null) {
      final times = json['daily']['time'] as List;
      final maxTemps = json['daily']['temperature_2m_max'] as List;
      final minTemps = json['daily']['temperature_2m_min'] as List;
      final codes = json['daily']['weather_code'] as List;

      int count = times.length > 7 ? 7 : times.length;
      for (int i = 0; i < count; i++) {
        daily.add(DailyForecast(
          date: DateTime.parse(times[i]),
          maxTemp: maxTemps[i].toDouble(),
          minTemp: minTemps[i].toDouble(),
          conditionCode: codes[i],
          condition: _mapCodeToCondition(codes[i]),
        ));
      }
    }

    return WeatherModel(
      cityName: cityName,
      temperature: json['current']['temperature_2m'].toDouble(),
      mainCondition: _mapCodeToCondition(json['current']['weather_code']),
      conditionCode: json['current']['weather_code'],
      humidity: json['current']['relative_humidity_2m']?.toInt() ?? 0,
      apparentTemperature: json['current']['apparent_temperature']?.toDouble() ?? 0.0,
      windSpeed: json['current']['wind_speed_10m']?.toDouble() ?? 0.0,
      hourlyForecast: hourly,
      dailyForecast: daily,
    );
  }

  static String _mapCodeToCondition(int code) {
    if (code == 0) return 'Clear';
    if (code == 1 || code == 2 || code == 3) return 'Cloudy';
    if (code >= 50 && code <= 69) return 'Rain';
    if (code >= 70 && code <= 79) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain'; // Showers
    if (code >= 85 && code <= 86) return 'Snow'; // Snow showers
    if (code >= 95 && code <= 99) return 'Storm';
    return 'Cloudy'; // Default fallback
  }
}