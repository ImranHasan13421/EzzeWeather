import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../weather/domain/entities/weather.dart';
import 'weather_icon.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
        const SizedBox(height: 10),
        WeatherIcon(
          conditionCode: weather.conditionCode,
          size: 120,
        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 10),
        Text(
          '${weather.temperature.round()}°',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        Text(
          weather.mainCondition,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}
