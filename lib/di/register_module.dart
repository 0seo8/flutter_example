import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  http.Client get client => http.Client();
}