import 'package:butterfly/core/di/di_module.dart';
import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:butterfly/ui/auth/login_screen.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/ui/home/bottombar/explore/bloc/explore_bloc.dart';
import 'package:butterfly/ui/home/bottombar/explore/details/product_detail_screen.dart';
import 'package:butterfly/ui/home/bottombar/explore/explore_screen.dart';
import 'package:butterfly/ui/home/bottombar/feeds/bloc/post_bloc.dart';
import 'package:butterfly/ui/home/bottombar/feeds/new_feeds_screen.dart';
import 'package:butterfly/ui/home/bottombar/profile/bloc/profile_bloc.dart';
import 'package:butterfly/ui/home/bottombar/profile/profile_screen.dart';
import 'package:butterfly/ui/home/home_screen.dart';
import 'package:butterfly/utils/app_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _exploreNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();
final _newsFeedsNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter getRouter(bool isLoggedIn) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: isLoggedIn ? Routes.explorePath : Routes.loginPath,
      routes: [
        /// Login Page
        GoRoute(
          path: Routes.loginPath,
          name: Routes.loginRouteName,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<LoginBloc>(),
            child: const LoginScreen(),
          ),
        ),

        /// Bottom Navigation 
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<HomeBloc>()),
                BlocProvider(create: (_) => getIt<BottomNavCubit>()),
              ],
              child: HomeScreen(navigationShell: navigationShell),
            );
          },
          branches: [
            /// Explore Branch
            StatefulShellBranch(
              navigatorKey: _exploreNavigatorKey,
              routes: [
                GoRoute(
                  path: Routes.explorePath,
                  
                  name: Routes.exploreRouteName,
                  pageBuilder: (context, state) => AppTransitions.fade(
                    context: context,
                    state: state,

                    child: BlocProvider(
                      create: (_) => getIt<ExploreBloc>(),
                      child: const ExploreScreen(),
                    ),

                  ),
                  routes: [
                    GoRoute(
                      path: 'product/:productId',
                      name: Routes.productDetailRouteName,

                      builder: (context, state) {
                        final productId = int.parse(state.pathParameters['productId']!);
                        return ProductDetailScreen(productId: productId);
                      },

                    ),
                  ],
                ),
              ],
            ),


            /// Profile Branch
            StatefulShellBranch(
              navigatorKey: _profileNavigatorKey,
              routes: [
                GoRoute(
                  path: Routes.profilePath,
                  name: Routes.profileRouteName,

                  pageBuilder: (context, state) => AppTransitions.fade(
                    context: context,
                    state: state,
                    child: BlocProvider(
                      create: (context) => getIt<ProfileBloc>(),
                      child: const ProfileScreen(),
                    ),
                  ),

                ),
              ],
            ),

            /// News Feeds Branch
            StatefulShellBranch(
              navigatorKey: _newsFeedsNavigatorKey,
              routes: [
                GoRoute(
                  path: Routes.newsFeeds,
                  name: Routes.newsFeedsName,

                  pageBuilder: (context, state) => AppTransitions.fade(
                    context: context,
                    state: state,

                     child: BlocProvider(
                      create: (_) => getIt<PostBloc>(),
                      child:  NewFeedsScreen(),
                    ),
                  ),

                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}