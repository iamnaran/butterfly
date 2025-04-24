import 'package:butterfly/core/database/entity/user/user_entity.dart';
import 'package:butterfly/core/network/base/resource.dart';

abstract class IAuthRepository {
  Stream<Resource<UserEntity?>> login(String username, String password);

  void logout();
}
