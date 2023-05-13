import 'dart:convert';
import 'dart:developer';
import 'package:auth_app/common/http_helper.dart';
import 'package:auth_app/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  AuthService() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        log(options.data.toString(), name:'onRequest');
        final accessToken =
            await storage.read(key: ApiConstants.accessTokenKey);
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log(response.toString(), name:'onResponse');
        return handler.next(response);
      },
      onError: (DioError error, handler) async {
        // Check for token expired error
        log(error.toString(), name:'onError');
        if (error.response?.statusCode == 401) {
          refreshAccessToken();
        }

        return handler.next(error);
      },
    ));
  }

  Future<bool> authenticate(String username, String password) async {
    try {
      final response = await dio.post(
        '/authenticate',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['token'];
        final refreshToken = data['refresh_token'];

        await storage.write(
            key: ApiConstants.accessTokenKey, value: accessToken);
        await storage.write(
            key: ApiConstants.refreshTokenKey, value: refreshToken);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await storage.read(key: ApiConstants.refreshTokenKey);
    if (refreshToken != null) {
      try {
        final response = await dio.post(
          '/refresh-token',
          data: {'refresh_token': refreshToken},
        );

        final accessToken = response.data['access_token'];
        if (accessToken != null) {
          await storage.write(
              key: ApiConstants.accessTokenKey, value: accessToken);
          return;
        }
      } catch (e) {
        print('Failed to refresh access token: $e');
      }
    }

    // Clear stored tokens if refresh token is invalid or refresh request fails
    await storage.delete(key: ApiConstants.accessTokenKey);
    await storage.delete(key: ApiConstants.refreshTokenKey);
  }

  Future<void> logout() async {
    await storage.delete(key: ApiConstants.accessTokenKey);
    await storage.delete(key: ApiConstants.refreshTokenKey);
  }
}
