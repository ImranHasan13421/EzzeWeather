import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/settings/settings_cubit.dart';
import '../../../../core/settings/settings_state.dart';
import '../../weather/domain/entities/weather.dart';
import 'weather_icon.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> forecast;

  const DailyForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return Container(
          margin: const EdgeInsets.all(20),
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

                final double minC = daily.minTemp;
                final double maxC = daily.maxTemp;
                final double displayMin = settings.isCelsius ? minC : (minC * 9 / 5 + 32);
                final double displayMax = settings.isCelsius ? maxC : (maxC * 9 / 5 + 32);

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
                            Text('${displayMin.round()}°', 
                                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                            const SizedBox(width: 10),
                            Text('${displayMax.round()}°', 
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
      },
    );
  }
}
