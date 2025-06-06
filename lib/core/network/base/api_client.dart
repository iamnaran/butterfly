import 'package:butterfly/core/network/base/token_interceptor.dart';
import 'package:butterfly/core/preference/pref_manager.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final PreferenceManager _preferenceManager;

  final String _baseUrl = 'https://dummyjson.com';

  ApiClient(this._preferenceManager);

  Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );

    dio.interceptors.addAll([
      TokenInterceptor(_preferenceManager),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}