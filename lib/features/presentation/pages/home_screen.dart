import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EzzeWeather', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search city...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (searchController.text.isNotEmpty) {
                      // Trigger the BLoC event
                      context.read<WeatherBloc>().add(GetWeatherForCity(searchController.text));
                      searchController.clear();
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<WeatherBloc>().add(GetWeatherForCity(value));
                  searchController.clear();
                }
              },
            ),
            const SizedBox(height: 40),

            // Listen to BLoC State changes
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherInitial) {
                  return const Text('Search for a city to see the weather.');
                } else if (state is WeatherLoading) {
                  return const CircularProgressIndicator();
                } else if (state is WeatherLoaded) {
                  return _buildWeatherCard(state.weather);
                } else if (state is WeatherError) {
                  return Text(state.message, style: const TextStyle(color: Colors.red));
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(weather) {
    return Column(
      children: [
        Text(weather.cityName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('${weather.temperature.round()}°C', style: const TextStyle(fontSize: 64)),
        Text(weather.mainCondition, style: const TextStyle(fontSize: 24, color: Colors.grey)),
      ],
    );
  }
}