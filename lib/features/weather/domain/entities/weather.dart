import 'package:equatable/equatable.dart';

class DailyForecast extends Equatable {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int conditionCode;
  final String condition;

  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.conditionCode,
    required this.condition,
  });

  @override
  List<Object?> get props => [date, maxTemp, minTemp, conditionCode, condition];
}

class HourlyForecast extends Equatable {
  final DateTime time;
  final double temperature;
  final int conditionCode;
  final String condition;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.conditionCode,
    required this.condition,
  });

  @override
  List<Object?> get props => [time, temperature, conditionCode, condition];
}

// Equatable allows us to compare objects easily (useful for BLoC)
class Weather extends Equatable {
  final String cityName;
  final String mainCondition;
  final double temperature;
  final int conditionCode;
  
  // New Fields
  final int humidity;
  final double windSpeed;
  final double apparentTemperature;
  final List<HourlyForecast> hourlyForecast;
  final List<DailyForecast> dailyForecast;

  const Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temperature,
    required this.conditionCode,
    required this.humidity,
    required this.windSpeed,
    required this.apparentTemperature,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  @override
  List<Object?> get props => [
        cityName,
        mainCondition,
        temperature,
        conditionCode,
        humidity,
        windSpeed,
        apparentTemperature,
        hourlyForecast,
        dailyForecast,
      ];
}