import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  /// Calls the Open-Meteo API.
  /// Throws a [ServerException] for all error codes.
  Future<WeatherModel> getWeather(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getWeather(String city) async {
    const geocodeUrl = 'https://geocoding-api.open-meteo.com/v1/search';
    const weatherUrl = 'https://api.open-meteo.com/v1/forecast';

    try {
      // 1. Get Coordinates
      final geoResponse = await client.get(Uri.parse('$geocodeUrl?name=$city&count=1'));
      if (geoResponse.statusCode != 200) throw Exception('Server Error');

      final geoData = jsonDecode(geoResponse.body);
      if (!geoData.containsKey('results')) throw Exception('City not found');

      final lat = geoData['results'][0]['latitude'];
      final lon = geoData['results'][0]['longitude'];
      final cityName = geoData['results'][0]['name'];

      // 2. Get Weather
      final weatherResponse = await client.get(Uri.parse(
          '$weatherUrl?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code'));

      if (weatherResponse.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(weatherResponse.body), cityName);
      } else {
        throw Exception('Server Error');
      }
    } catch (e) {
      // In Dart, exceptions are caught by the repository
      throw Exception('Failed to fetch weather data');
    }
  }
}