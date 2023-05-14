import 'dart:developer';

import 'package:auth_app/common/http_helper.dart';
import 'package:auth_app/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NamesService {
  final storage = const FlutterSecureStorage();

  Future<List<String>> getNames() async {
    try {
      final response = await dio.get('/names');
      log(response.toString(), name: 'response');
      if (response.statusCode == 200) {
        final data = response.data;
        final names = List<String>.from(data.map((name) => name['name']));

        return names;
      } else {
        throw Exception('Failed to retrieve names');
      }
    } catch (e) {
      throw Exception('Failed to retrieve names');
    }
  }

  Future<void> addName(String name) async {
    final response = await dio.post(
      '/names',
      data: {'name': name},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add name');
    }
  }
}
