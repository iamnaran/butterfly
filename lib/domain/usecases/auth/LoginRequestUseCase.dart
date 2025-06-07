import 'package:butterfly/core/network/resource/resource.dart';
import 'package:butterfly/data/local/database/entity/user/user_entity.dart';
import 'package:butterfly/data/repository/auth/auth_repository.dart';

class LoginRequestUseCase {
  final IAuthRepository _repository;

  LoginRequestUseCase(this._repository);

  Stream<Resource<UserEntity?>> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username, password);
  }
}