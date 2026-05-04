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

// Import dependency injection and the new Use Case
import 'package:ezze_weather/injection_container.dart' as di;
import 'package:ezze_weather/features/weather/domain/usecases/search_cities.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                title: Text(
                  'EzzeWeather', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildSearchBar(context),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return Center(
                      child: Text(
                        'Search for a city to see the weather.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).animate().fadeIn(),
                    );
                  } else if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return Column(
                      children: [
                        CurrentWeatherCard(weather: state.weather),
                        WeatherDetailsRow(weather: state.weather),
                        HourlyForecastList(forecast: state.weather.hourlyForecast),
                        DailyForecastList(forecast: state.weather.dailyForecast),
                        const SizedBox(height: 40),
                      ],
                    );
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
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Autocomplete<String>(
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
        final cityName = selection.split(',').first;
        context.read<WeatherBloc>().add(GetWeatherForCity(cityName));
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Search city...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    final cityName = controller.text.split(',').first;
                    context.read<WeatherBloc>().add(GetWeatherForCity(cityName));
                    focusNode.unfocus();
                  }
                },
              ),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                final cityName = value.split(',').first;
                context.read<WeatherBloc>().add(GetWeatherForCity(cityName));
                focusNode.unfocus();
              }
            },
          ),
        );
      },
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2);
  }
}