
import 'package:butterfly/network/api_services.dart';
import 'package:butterfly/network/endpoints.dart';

class AuthRepository {
  final Networkapiservice networkapiservice = Networkapiservice();

  Future login(String username, String password) async {
    final String url = Endpoints.login();
    final data = {
      'username': username,
      'password': password,
    };

    try {
      final response = await networkapiservice.getPostApiResponse(url, data);
      return response; // You can parse the response here
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}