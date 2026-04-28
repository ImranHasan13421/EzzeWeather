import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ezze_weather/features/weather/domain/usecases/get_current_weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;

  WeatherBloc({required this.getCurrentWeather}) : super(WeatherInitial()) {
    on<GetWeatherForCity>((event, emit) async {
      emit(WeatherLoading());

      final failureOrWeather = await getCurrentWeather(event.city);

      failureOrWeather.fold(
            (failure) => emit(const WeatherError('Server Failure: Could not fetch data.')),
            (weather) => emit(WeatherLoaded(weather)),
      );
    });
  }
}