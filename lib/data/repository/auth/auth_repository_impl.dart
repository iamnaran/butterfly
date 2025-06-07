
import 'package:butterfly/data/local/database/entity/user/user_entity.dart';
import 'package:butterfly/data/local/database/manager/user_db_manager.dart';
import 'package:butterfly/data/remote/model/auth/auth_mapper.dart';
import 'package:butterfly/data/remote/model/auth/login_request/login_request.dart';
import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/core/network/resource/network_request.dart';
import 'package:butterfly/core/network/services/auth/auth_service.dart';
import 'package:butterfly/data/local/preference/pref_manager.dart';
import 'package:butterfly/data/repository/auth/auth_repository.dart';
import 'package:butterfly/utils/app_logger.dart';

class AuthRepositoryImpl extends IAuthRepository {
  final AuthService _authService;
  final UserDatabaseManager _userDatabaseManager;
  final PreferenceManager _preferenceManager;

  AuthRepositoryImpl(this._authService, this._userDatabaseManager,
      this._preferenceManager);


   @override
  Stream<Resource<UserEntity>> login(String username, String password) {
    final loginRequest = LoginRequest(username: username, password: password);
    AppLogger.showInfo("Initiating login for $username");

    return NetworkRequest<UserEntity>(
      fetchFromApi: () async {
        final response = await _authService.login(loginRequest);
        AppLogger.showInfo("Login success: ${response.username}");
        return AuthMapper.mapUserResponseToEntity(response);
      },
      saveApiResult: (user) async {
        await _userDatabaseManager.saveUser(user);
        await _preferenceManager.setLoggedIn(true);
        await _preferenceManager.saveToken(user.accessToken);
      },
    ).asStream(null);
  }

 @override
  void logout() {
    _userDatabaseManager.deleteAllUsers();
    _preferenceManager.setLoggedIn(false);
    _preferenceManager.clearToken();
    AppLogger.showInfo("User logged out");
  }

  @override
  Future<UserEntity?> getLoggedInUser() async {
    try {
      final user = await _userDatabaseManager.getFirstAndOnlyUser();
      if (user != null) {
        AppLogger.showInfo("Fetched user: ${user.username}");
      } else {
        AppLogger.showError("No logged-in user found");
      }
      return user;
    } catch (e) {
      AppLogger.showError("Error fetching user: $e");
      return null;
    }
  }
}
