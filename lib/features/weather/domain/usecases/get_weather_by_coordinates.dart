import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherByCoordinates {
  final WeatherRepository repository;

  GetWeatherByCoordinates(this.repository);

  Future<Either<Failure, Weather>> call(double lat, double lon, String? cityName) async {
    return await repository.getCurrentWeatherByCoordinates(lat, lon, cityName);
  }
}
