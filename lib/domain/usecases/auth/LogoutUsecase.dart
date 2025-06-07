import 'package:butterfly/data/repository/auth/auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  void call() {
    _repository.logout();
  }
}