import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:ezze_weather/features/weather/domain/entities/weather.dart';
import 'package:ezze_weather/features/weather/domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String city) async {
    try {
      final remoteWeather = await remoteDataSource.getWeather(city);
      return Right(remoteWeather);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> searchCities(String query) async {
    try {
      final cities = await remoteDataSource.searchCities(query);
      return Right(cities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}