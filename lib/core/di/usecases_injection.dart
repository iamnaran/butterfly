

import 'package:butterfly/domain/usecases/auth/GetLoggedInUserUseCase.dart';
import 'package:butterfly/domain/usecases/auth/LoginRequestUseCase.dart';
import 'package:butterfly/domain/usecases/auth/LogoutUsecase.dart';
import 'package:butterfly/domain/usecases/explore/GetProductListUseCase.dart';
import 'package:butterfly/domain/usecases/explore/GetProductsByIdUseCase.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void registerUseCases() {
  getIt.registerLazySingleton(() => LoginRequestUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetLoggedInUserUseCase(getIt()));

  getIt.registerLazySingleton(() => GetProductListUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductByIdUseCase(getIt()));

}



