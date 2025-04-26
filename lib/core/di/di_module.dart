import 'package:butterfly/core/database/manager/post_db_manager.dart';
import 'package:butterfly/core/database/manager/product_db_manager.dart';
import 'package:butterfly/core/database/manager/user_db_manager.dart';
import 'package:butterfly/core/network/services/api_services.dart';
import 'package:butterfly/core/network/services/api_services_impl.dart';
import 'package:butterfly/core/preference/pref_manager.dart';
import 'package:butterfly/core/repository/auth/auth_repository.dart';
import 'package:butterfly/core/repository/auth/auth_repository_impl.dart';
import 'package:butterfly/core/repository/explore/explore_repository.dart';
import 'package:butterfly/core/repository/explore/explore_repository_impl.dart';
import 'package:butterfly/core/repository/post/post_repository.dart';
import 'package:butterfly/core/repository/post/post_repository_impl.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/ui/home/bottombar/explore/bloc/explore_bloc.dart';
import 'package:butterfly/ui/home/bottombar/explore/details/bloc/product_detail_bloc.dart';
import 'package:butterfly/ui/home/bottombar/feeds/bloc/post_bloc.dart';
import 'package:butterfly/ui/home/bottombar/profile/bloc/profile_bloc.dart';
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

  // Hive DB Managers Injections
  getIt.registerLazySingleton<ProductDatabaseManager>(
      () => ProductDatabaseManager());

  getIt.registerLazySingleton<UserDatabaseManager>(() => UserDatabaseManager());
  getIt.registerLazySingleton<PostDatabaseManager>(() => PostDatabaseManager());

  // Repository Injections
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(getIt.get<IApiServices>(),
        getIt.get<UserDatabaseManager>(), getIt.get<PreferenceManager>()),
  );
  getIt.registerLazySingleton<IExploreRepository>(
    () => ExploreRepositoryImpl(
        getIt.get<IApiServices>(), getIt.get<ProductDatabaseManager>()),
  );
  getIt.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(
        getIt.get<IApiServices>(), getIt.get<PostDatabaseManager>()),
  );

  // Bottom Navigation()
  getIt.registerFactory<BottomNavCubit>(
    () => BottomNavCubit(),
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

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt.get<IAuthRepository>()),
  );

  getIt.registerFactory<PostBloc>(
    () => PostBloc(getIt.get<IPostRepository>()),
  );

  getIt.registerFactory<ProductDetailBloc>(
    () => ProductDetailBloc(getIt.get<IExploreRepository>()),
  );
}
