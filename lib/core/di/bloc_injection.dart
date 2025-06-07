import 'package:butterfly/data/repository/auth/auth_repository.dart';
import 'package:butterfly/data/repository/explore/explore_repository.dart';
import 'package:butterfly/data/repository/post/post_repository.dart';
import 'package:butterfly/domain/usecases/auth/GetLoggedInUserUseCase.dart';
import 'package:butterfly/domain/usecases/auth/LoginRequestUseCase.dart';
import 'package:butterfly/domain/usecases/auth/LogoutUsecase.dart';
import 'package:butterfly/domain/usecases/explore/GetProductListUseCase.dart';
import 'package:butterfly/domain/usecases/explore/GetProductsByIdUseCase.dart';
import 'package:get_it/get_it.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/ui/home/bottombar/explore/bloc/explore_bloc.dart';
import 'package:butterfly/ui/home/bottombar/explore/details/bloc/product_detail_bloc.dart';
import 'package:butterfly/ui/home/bottombar/feeds/bloc/post_bloc.dart';
import 'package:butterfly/ui/home/bottombar/profile/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

void registerBlocs() {
  getIt.registerFactory<BottomNavCubit>(() => BottomNavCubit());

  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt<LoginRequestUseCase>(), getIt<LogoutUseCase>(), getIt<GetLoggedInUserUseCase>()));

  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<IAuthRepository>()));

  getIt.registerFactory<ExploreBloc>(() => ExploreBloc(getIt<GetProductListUseCase>(), getIt<GetProductByIdUseCase>()));

  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getIt<IAuthRepository>()));

  getIt.registerFactory<PostBloc>(() => PostBloc(getIt<IPostRepository>()));

  getIt.registerFactory<ProductDetailBloc>(() => ProductDetailBloc(getIt<IExploreRepository>()));
}