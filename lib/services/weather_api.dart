import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherApi {
  // Open-Meteo requires latitude and longitude instead of city names.
  // We use the Geocoding API to turn the city name into coordinates first.
  static const String geocodeUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String weatherUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData?> getWeather(String city) async {
    try {
      // 1. Get Coordinates for the city
      final geoResponse = await http.get(Uri.parse('$geocodeUrl?name=$city&count=1'));

      if (geoResponse.statusCode != 200) return null;

      final geoData = jsonDecode(geoResponse.body);
      if (!geoData.containsKey('results')) return null; // City not found

      final double lat = geoData['results'][0]['latitude'];
      final double lon = geoData['results'][0]['longitude'];
      final String cityName = geoData['results'][0]['name'];

      // 2. Get Weather using those coordinates
      // We are asking for current temperature, weather code (for icons), and wind speed
      final weatherResponse = await http.get(Uri.parse(
          '$weatherUrl?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code,wind_speed_10m'));

      if (weatherResponse.statusCode == 200) {
        final weatherJson = jsonDecode(weatherResponse.body);

        // Return a customized WeatherData object (you will need to update your model slightly)
        return WeatherData(
          cityName: cityName,
          temperature: weatherJson['current']['temperature_2m'].toDouble(),
          // Open-Meteo uses WMO weather codes instead of text descriptions
          description: _getWeatherDescription(weatherJson['current']['weather_code']),
          iconCode: '10d', // You can map WMO codes to local asset icons later
        );
      }
      return null;
    } catch (e) {
      print('Network error: $e');
      return null;
    }
  }

  // Helper method to convert Open-Meteo's WMO codes to text
  String _getWeatherDescription(int code) {
    switch (code) {
      case 0: return 'Clear sky';
      case 1: case 2: case 3: return 'Mainly clear, partly cloudy, and overcast';
      case 45: case 48: return 'Fog and depositing rime fog';
      case 51: case 53: case 55: return 'Drizzle: Light, moderate, and dense intensity';
      case 61: case 63: case 65: return 'Rain: Slight, moderate and heavy intensity';
      case 71: case 73: case 75: return 'Snow fall: Slight, moderate, and heavy intensity';
      case 95: return 'Thunderstorm: Slight or moderate';
      default: return 'Unknown';
    }
  }
}