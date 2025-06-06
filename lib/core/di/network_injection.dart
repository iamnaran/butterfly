import 'package:butterfly/core/network/services/explore/explore_service.dart';
import 'package:butterfly/core/network/services/post/post_service.dart';
import 'package:get_it/get_it.dart';
import 'package:butterfly/core/network/base/api_client.dart';
import 'package:butterfly/core/network/services/auth/auth_service.dart';

final getIt = GetIt.instance;

void registerNetwork() {
  
  getIt.registerLazySingleton(() => ApiClient(getIt()));

  getIt.registerLazySingleton(() => getIt<ApiClient>().createDio());

  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt()));
  getIt.registerLazySingleton<ExploreService>(() => ExploreService(getIt()));
  getIt.registerLazySingleton<PostService>(() => PostService(getIt()));


}