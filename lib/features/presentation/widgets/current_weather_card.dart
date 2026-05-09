import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/settings/settings_state.dart';
import '../../weather/domain/entities/weather.dart';
import 'weather_icon.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        final double tempC = weather.temperature;
        final double displayTemp = settings.isCelsius ? tempC : (tempC * 9 / 5 + 32);
        final String unitStr = settings.isCelsius ? '°C' : '°F';

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
              '${displayTemp.round()}$unitStr',
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
      },
    );
  }
}
