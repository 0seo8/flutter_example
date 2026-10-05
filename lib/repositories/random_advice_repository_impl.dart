

import 'package:injectable/injectable.dart';

import '../data/datasources/api_service.dart';
import '../domain/repositories/random_advice_repository.dart';

@LazySingleton(as: RandomAdviceRepository)
class RandomAdviceRepositoryImpl implements RandomAdviceRepository{
  RandomAdviceRepositoryImpl({required ApiService apiService}) : _apiService = apiService;
  
  final ApiService _apiService;

  @override
  Future<String> getRandomAdvice() async {
    return await _apiService.getRandomAdvice();
  }
}