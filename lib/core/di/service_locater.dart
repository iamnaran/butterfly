import 'package:butterfly/core/di/service_locater.config.dart';
import 'package:butterfly/core/repository/auth/auth_repository.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependenciesInjection() async => getIt.init();


@module
abstract class BlocModule {
  @injectable
  LoginBloc loginBloc(IAuthRepository repo) => LoginBloc(repo);
}