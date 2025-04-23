import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/database/hive_db_manager.dart';
import 'package:butterfly/core/model/auth/auth_mapper.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/core/network/base/endpoints.dart';
import 'package:butterfly/core/network/base/resource.dart';
import 'package:butterfly/core/network/network_request.dart';
import 'package:butterfly/core/repository/auth/auth_repository.dart';
import 'package:butterfly/utils/app_logger.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as : IAuthRepository)
class AuthRepositoryImpl extends IAuthRepository{

final IApiServices networkapiservice;
final HiveDbManager _hiveManager;

  AuthRepositoryImpl(this.networkapiservice, this._hiveManager, {required IApiServices apiServices, required HiveDbManager hiveManager});

   @override
    Stream<Resource<UserEntity?>> login(String username, String password) {
    final String url = Endpoints.login(); 
    final data = {
      'username': username,
      'password': password,
    };

    AppLogger.showError("Login URL: $url, Data: $data");
    // Create the NetworkRequest with logic for login
    final networkRequest = NetworkRequest<UserEntity?>(
      fetchFromApi: () async {
        AppLogger.showError("Login Api Requested");

        try {
          // Fetch the user data from the API
          final response = await networkapiservice.getPostApiResponse(url, data);
          AppLogger.showError(response.toString());
          return AuthMapper.mapUserResponseToEntity(response);
        } catch (e) {
          AppLogger.showError(e.toString());
          throw Exception('Login failed: $e');
        }
      },
      saveApiResult: (userEntity) async {
        await _hiveManager.saveLoggedInUser(userEntity!);
      },
      shouldFetch: (localData) {
        // Always fetch from API for login
        return true;
      },
    );
    AppLogger.showError("Login request initiated");

    // Return the stream of the login process (API call and result saving)
    return networkRequest.asStream(null); // Passing `null` as no local data
  }
}