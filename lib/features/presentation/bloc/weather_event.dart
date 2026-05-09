import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForCity extends WeatherEvent {
  final String city;

  const GetWeatherForCity(this.city);

  @override
  List<Object> get props => [city];
}

class GetWeatherForCoordinates extends WeatherEvent {
  final double lat;
  final double lon;
  final String? cityName;

  const GetWeatherForCoordinates(this.lat, this.lon, [this.cityName]);

  @override
  List<Object> get props => [lat, lon, cityName ?? ''];
}