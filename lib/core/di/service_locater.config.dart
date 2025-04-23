// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:butterfly/core/database/hive_db_manager.dart' as _i226;
import 'package:butterfly/core/network/services/api_services.dart' as _i318;
import 'package:butterfly/core/network/services/api_services_impl.dart'
    as _i510;
import 'package:butterfly/core/repository/auth/auth_repository.dart' as _i1026;
import 'package:butterfly/core/repository/auth/auth_repository_impl.dart'
    as _i895;
import 'package:butterfly/ui/auth/bloc/login_bloc.dart' as _i195;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i226.HiveDbManager>(() => _i226.HiveDbManager());
    gh.lazySingleton<_i318.IApiServices>(() => _i510.Networkapiservice());
    gh.lazySingleton<_i1026.IAuthRepository>(() => _i895.AuthRepositoryImpl(
          gh<_i318.IApiServices>(),
          gh<_i226.HiveDbManager>(),
          apiServices: gh<_i318.IApiServices>(),
          hiveManager: gh<_i226.HiveDbManager>(),
        ));
    gh.factory<_i195.LoginBloc>(
        () => _i195.LoginBloc(gh<_i1026.IAuthRepository>()));
    return this;
  }
}
