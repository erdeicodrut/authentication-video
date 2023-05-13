import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL']!;
  static const String contentType = 'application/json';
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
}
