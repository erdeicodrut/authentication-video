import 'package:auth_app/constants.dart';
import 'package:dio/dio.dart';

late Dio dio;

initDio() {
  BaseOptions options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    contentType: ApiConstants.contentType,
  );
  dio = Dio(options);
}
