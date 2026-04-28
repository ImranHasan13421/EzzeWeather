import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/data/datasources/weather_remote_data_source.dart';
import 'features/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_current_weather.dart';
import 'features/presentation/bloc/weather_bloc.dart';

final sl = GetIt.instance; // sl stands for Service Locator

void init() {
  // BLoC
  sl.registerFactory(() => WeatherBloc(getCurrentWeather: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
        () => WeatherRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}