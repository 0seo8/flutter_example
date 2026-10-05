import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@singleton
class ApiService {
  ApiService({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<String> getRandomAdvice() async {
   try {
    final response =await _client.get(
      Uri.parse('https://api.adviceslip.com/advice'),
    );
    final responseBody = jsonDecode(response.body);
    return responseBody['slip']['advice'];
   }catch(e){
    rethrow;
   }
  }
}