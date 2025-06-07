import 'package:get_it/get_it.dart';
import 'package:butterfly/data/local/database/manager/post_db_manager.dart';
import 'package:butterfly/data/local/database/manager/product_db_manager.dart';
import 'package:butterfly/data/local/database/manager/user_db_manager.dart';

final getIt = GetIt.instance;

void registerDatabaseManagers() {
  getIt.registerLazySingleton<ProductDatabaseManager>(() => ProductDatabaseManager());
  getIt.registerLazySingleton<UserDatabaseManager>(() => UserDatabaseManager());
  getIt.registerLazySingleton<PostDatabaseManager>(() => PostDatabaseManager());
}