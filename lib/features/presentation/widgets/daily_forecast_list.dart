import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../weather/domain/entities/weather.dart';
import 'weather_icon.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> forecast;

  const DailyForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...forecast.asMap().entries.map((entry) {
            final index = entry.key;
            final daily = entry.value;
            final dateString = index == 0 ? 'Today' : DateFormat('EEEE').format(daily.date);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(dateString, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Expanded(
                    flex: 1,
                    child: WeatherIcon(conditionCode: daily.conditionCode, size: 30),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${daily.minTemp.round()}°', 
                             style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                        const SizedBox(width: 10),
                        Text('${daily.maxTemp.round()}°', 
                             style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (600 + index * 50).ms).slideX(begin: 0.2);
          }),
        ],
      ),
    );
  }
}
