import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/settings/settings_state.dart';
import '../../weather/domain/entities/weather.dart';

class WeatherDetailsRow extends StatelessWidget {
  final Weather weather;

  const WeatherDetailsRow({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        final double feelsLikeC = weather.apparentTemperature;
        final double displayFeelsLike = settings.isCelsius ? feelsLikeC : (feelsLikeC * 9 / 5 + 32);
        final String unitStr = settings.isCelsius ? '°C' : '°F';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(context, Icons.water_drop, '${weather.humidity}%', 'Humidity'),
              _buildDetailItem(context, Icons.air, '${weather.windSpeed} km/h', 'Wind'),
              _buildDetailItem(context, Icons.thermostat, '${displayFeelsLike.round()}$unitStr', 'Feels like'),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
      },
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
