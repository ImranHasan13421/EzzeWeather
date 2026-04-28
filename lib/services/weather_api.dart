import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../utils/constants.dart';

class WeatherApi {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData?> getWeather(String city) async {
    try {
      final url = Uri.parse('$baseUrl?q=$city&appid=${Constants.apiKey}&units=metric');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return WeatherData.fromJson(jsonData);
      } else {
        print('Error fetching data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network error: $e');
      return null;
    }
  }
}