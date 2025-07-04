import 'package:butterfly/data/local/database/manager/post_db_manager.dart';
import 'package:butterfly/data/local/database/manager/product_db_manager.dart';
import 'package:butterfly/data/local/database/manager/user_db_manager.dart';
import 'package:butterfly/core/network/services/auth/auth_service.dart';
import 'package:butterfly/core/network/services/explore/explore_service.dart';
import 'package:butterfly/core/network/services/post/post_service.dart';
import 'package:butterfly/data/local/preference/pref_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:butterfly/data/repository/auth/auth_repository.dart';
import 'package:butterfly/data/repository/auth/auth_repository_impl.dart';
import 'package:butterfly/data/repository/explore/explore_repository.dart';
import 'package:butterfly/data/repository/explore/explore_repository_impl.dart';
import 'package:butterfly/data/repository/post/post_repository.dart';
import 'package:butterfly/data/repository/post/post_repository_impl.dart';

final getIt = GetIt.instance;

void registerRepositories() {
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthService>(),
      getIt<UserDatabaseManager>(),
      getIt<PreferenceManager>(),
    ),
  );

  getIt.registerLazySingleton<IExploreRepository>(
    () => ExploreRepositoryImpl(
      getIt<ExploreService>(),
      getIt<ProductDatabaseManager>(),
    ),
  );

  getIt.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(
      getIt<PostService>(),
      getIt<PostDatabaseManager>(),
    ),
  );
}