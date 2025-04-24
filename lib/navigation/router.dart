import 'package:butterfly/core/di/di_module.dart';
import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:butterfly/ui/auth/login_screen.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/bottombar/BottomNavCubit.dart';
import 'package:butterfly/ui/home/bottombar/explore/bloc/explore_bloc.dart';
import 'package:butterfly/ui/home/bottombar/explore/explore_screen.dart';
import 'package:butterfly/ui/home/bottombar/profile/profile_screen.dart';
import 'package:butterfly/ui/home/bottombar/search/search_screen.dart';
import 'package:butterfly/ui/home/home_screen.dart';
import 'package:butterfly/utils/app_transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter getRouter(bool isLoggedIn) {
    return GoRouter(
      initialLocation: isLoggedIn ? Routes.explorePath : Routes.loginPath,
      routes: [
        GoRoute(
          path: Routes.loginPath,
          name: Routes.loginRouteName,
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<LoginBloc>(),
            child: const LoginScreen(),
          ),
        ),

        ShellRoute(builder: (context, state, child) {
            return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => getIt<HomeBloc>()),
                  BlocProvider(create: (_) => getIt<BottomNavCubit>()),
                ],
                child: HomeScreen(child: child),
              );
        },
          routes: [
            GoRoute(
              path: Routes.explorePath,
              name: Routes.exploreRouteName,
              pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: BlocProvider(
                        create: (context) => getIt<ExploreBloc>(),
                        child: const ExploreScreen(),
                      ),
                ),
            ),

            GoRoute(
              path: Routes.profilePath,
              name: Routes.profileRouteName,
              pageBuilder: (context, state) => AppTransitions.fade(
                context: context,
                state: state,
                child: const ProfileScreen(),
              ),
            ),

            GoRoute(
              path: Routes.searchPath,
              name: Routes.searchRouteName,
              pageBuilder: (context, state) => AppTransitions.fade(
                context: context,
                state: state,
                child: const SearchScreen(),
              ),
            ),
          ]
      ),

        
      ],
    );
  }




}
