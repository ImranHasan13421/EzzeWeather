import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../services/weather_api.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  final TextEditingController _searchController = TextEditingController();

  WeatherData? _weatherData;
  bool _isLoading = false;

  void _fetchWeather(String city) async {
    setState(() => _isLoading = true);

    final data = await _weatherApi.getWeather(city);

    setState(() {
      _weatherData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundLight,
      appBar: AppBar(
        title: const Text('EzzeWeather', style: TextStyle(color: Colors.white)),
        backgroundColor: Constants.primaryBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search city...',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Constants.primaryBlue),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _fetchWeather(_searchController.text);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) _fetchWeather(value);
              },
            ),

            const SizedBox(height: 40),

            // Weather Display
            if (_isLoading)
              const CircularProgressIndicator(color: Constants.primaryBlue)
            else if (_weatherData != null)
              _buildWeatherCard()
            else
              const Text('Search for a city to see the weather.',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Custom Widget for the Weather Details
  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Text(_weatherData!.cityName, style: Constants.cityStyle),
          const SizedBox(height: 10),
          // Fetches the weather icon directly from OpenWeatherMap
          Image.network(
            'https://openweathermap.org/img/wn/${_weatherData!.iconCode}@2x.png',
            height: 100,
          ),
          Text('${_weatherData!.temperature.round()}°C', style: Constants.tempStyle),
          Text(
            _weatherData!.description.toUpperCase(),
            style: const TextStyle(fontSize: 18, color: Colors.grey, letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}