import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

// Import dependency injection and the new Use Case
import 'package:ezze_weather/injection_container.dart' as di;
import 'package:ezze_weather/features/weather/domain/usecases/search_cities.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EzzeWeather', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // The new Autocomplete Search Bar
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }

                // Fetch live suggestions
                final failureOrCities = await di.sl<SearchCities>().call(textEditingValue.text);

                return failureOrCities.fold(
                      (failure) => const Iterable<String>.empty(),
                      (cities) => cities,
                );
              },
              onSelected: (String selection) {
                // Extracts "London" from "London, United Kingdom"
                final cityName = selection.split(',').first;
                context.read<WeatherBloc>().add(GetWeatherForCity(cityName));
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.blueAccent),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          final cityName = controller.text.split(',').first;
                          context.read<WeatherBloc>().add(GetWeatherForCity(cityName));
                          controller.clear();
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      final cityName = value.split(',').first;
                      context.read<WeatherBloc>().add(GetWeatherForCity(cityName));
                      controller.clear();
                    }
                  },
                );
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