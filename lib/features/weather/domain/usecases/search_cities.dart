import 'package:dartz/dartz.dart';
import 'package:ezze_weather/core/error/failures.dart';
import 'package:ezze_weather/features/weather/domain/repositories/weather_repository.dart';

class SearchCities {
  final WeatherRepository repository;

  SearchCities(this.repository);

  Future<Either<Failure, List<String>>> call(String query) async {
    return await repository.searchCities(query);
  }
}