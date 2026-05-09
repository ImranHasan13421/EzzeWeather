import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ezze_weather/features/weather/domain/usecases/get_weather_by_coordinates.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/location_service.dart';
import 'core/settings/settings_cubit.dart';
import 'features/data/datasources/weather_remote_data_source.dart';
import 'features/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_current_weather.dart';
import 'features/weather/domain/usecases/search_cities.dart';
import 'features/presentation/bloc/weather_bloc.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  // Services
  sl.registerLazySingleton(() => LocationService());

  // Settings
  sl.registerFactory(() => SettingsCubit(sharedPreferences: sl()));

  // BLoC
  sl.registerFactory(() => WeatherBloc(
    getCurrentWeather: sl(),
    getWeatherByCoordinates: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton(() => SearchCities(sl())); // <-- NEW
  sl.registerLazySingleton(() => GetWeatherByCoordinates(sl()));

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
        () => WeatherRemoteDataSourceImpl(client: sl()),
  );
}