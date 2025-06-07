

import 'package:butterfly/data/local/preference/pref_manager.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final PreferenceManager _preferenceManager;

  TokenInterceptor(this._preferenceManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _preferenceManager.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}