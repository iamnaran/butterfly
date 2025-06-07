import 'package:butterfly/data/local/database/entity/user/user_entity.dart';
import 'package:butterfly/data/repository/auth/auth_repository.dart';

class GetLoggedInUserUseCase {
  final IAuthRepository _repository;

  GetLoggedInUserUseCase(this._repository);

  Future<UserEntity?> call() {
    return _repository.getLoggedInUser();
  }

}