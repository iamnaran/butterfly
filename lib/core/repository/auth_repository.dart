import 'package:butterfly/core/data/database/hive_constants.dart';
import 'package:butterfly/core/database/entity/user_entity.dart';
import 'package:butterfly/core/database/hive_db_manager';
import 'package:butterfly/core/network/api_services.dart';
import 'package:butterfly/core/network/endpoints.dart';

class AuthRepository {
  final Networkapiservice networkapiservice = Networkapiservice();
  final HiveManager<UserEntity> _hiveManager = HiveManager<UserEntity>(boxName: HiveConstants.userBox);


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