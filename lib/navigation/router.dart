import 'package:butterfly/core/di/service_locater.dart';
import 'package:butterfly/navigation/routes.dart';
import 'package:butterfly/ui/auth/bloc/login_bloc.dart';
import 'package:butterfly/ui/auth/login_screen.dart';
import 'package:butterfly/ui/home/bloc/home_bloc.dart';
import 'package:butterfly/ui/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter getRouter(bool isLoggedIn) {
    return GoRouter(
      initialLocation: isLoggedIn ? Routes.home : Routes.login,
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<LoginBloc>(),
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<HomeBloc>(),
            child: const HomeScreen(),
          ),
        ),
      ],
    );
  }
}