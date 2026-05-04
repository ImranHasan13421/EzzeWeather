import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../weather/domain/entities/weather.dart';
import 'weather_icon.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> forecast;

  const HourlyForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Today',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final hourly = forecast[index];
              final timeString = DateFormat('j').format(hourly.time);

              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(timeString, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    WeatherIcon(conditionCode: hourly.conditionCode, size: 30),
                    const SizedBox(height: 10),
                    Text('${hourly.temperature.round()}°', 
                         style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ).animate().fadeIn(delay: (500 + index * 50).ms).slideX(begin: 0.2);
            },
          ),
        ),
      ],
    );
  }
}
