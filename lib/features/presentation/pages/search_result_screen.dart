import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/weather_details_row.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_list.dart';
import 'package:ezze_weather/injection_container.dart' as di;

class SearchResultScreen extends StatefulWidget {
  final String cityName;

  const SearchResultScreen({super.key, required this.cityName});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late WeatherBloc _weatherBloc;

  @override
  void initState() {
    super.initState();
    _weatherBloc = di.sl<WeatherBloc>();
    _weatherBloc.add(GetWeatherForCity(widget.cityName));
  }

  @override
  void dispose() {
    _weatherBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _weatherBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.cityName, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark 
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)] 
                : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
            ),
          ),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading || state is WeatherInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WeatherLoaded) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CurrentWeatherCard(weather: state.weather),
                      WeatherDetailsRow(weather: state.weather),
                      HourlyForecastList(forecast: state.weather.hourlyForecast),
                      DailyForecastList(forecast: state.weather.dailyForecast),
                      const SizedBox(height: 40),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms);
              } else if (state is WeatherError) {
                return Center(
                  child: Text(
                    state.message, 
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  ).animate().shake(),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
