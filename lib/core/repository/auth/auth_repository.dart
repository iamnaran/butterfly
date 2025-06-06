import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/network/resource/resource.dart';

abstract class IAuthRepository {
  
  Stream<Resource<UserEntity?>> login(String username, String password);
  Future<UserEntity?> getLoggedInUser();
  void logout();
}
