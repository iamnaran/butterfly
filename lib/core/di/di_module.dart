import 'package:butterfly/core/database/manager/product_db_manager.dart';
import 'package:butterfly/core/database/manager/user_db_manager.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/core/network/services/api_services_impl.dart';
import 'package:butterfly/core/preference/pref_manager.dart';
import 'package:butterfly/core/repository/auth/auth_repository.dart';
import 'package:butterfly/core/repository/auth/auth_repository_impl.dart';
import 'package:butterfly/core/repository/explore/explore_repository.dart';
import 'package:butterfly/core/repository/explore/explore_repository_impl.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/ui/home/bottombar/explore/bloc/explore_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependenciesInjection() async {

  // For Local Values & Status
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<PreferenceManager>(
        () => PreferenceManager(getIt.get<SharedPreferences>()),
  );

  // Register NetworkApiService
  getIt.registerLazySingleton<IApiServices>(() => NetworkApiService());

  // Register PrefManager
  getIt.registerLazySingleton<IAuthRepository>(
        () => AuthRepositoryImpl(getIt.get<IApiServices>(), getIt.get<UserDatabaseManager>(), getIt.get<PreferenceManager>()),
  );

  // Hive DB Managers Injections
  getIt.registerLazySingleton<ProductDatabaseManager>(() => ProductDatabaseManager());
  getIt.registerLazySingleton<UserDatabaseManager>(() => UserDatabaseManager());


  // Repository Injections
  getIt.registerLazySingleton<IExploreRepository>(
        () => ExploreRepositoryImpl(getIt.get<IApiServices>(), getIt.get<ProductDatabaseManager>()),
  );

  // Bloc Injections
  getIt.registerFactory<LoginBloc>(
        () => LoginBloc(getIt.get<IAuthRepository>()),
  );

  getIt.registerFactory<HomeBloc>(
        () => HomeBloc(getIt.get<IAuthRepository>()),
  );

  getIt.registerFactory<ExploreBloc>(
        () => ExploreBloc(getIt.get<IExploreRepository>()),
  );

  getIt.registerLazySingleton<BottomNavCubit>(
        () => BottomNavCubit(),
  );

}
