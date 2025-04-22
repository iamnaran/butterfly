import 'package:butterfly/navigation/routes_name.dart';
import 'package:butterfly/ui/auth/login_screen.dart';
import 'package:butterfly/ui/blank/blank_screen.dart';
import 'package:butterfly/ui/home/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {

  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
    
      case RoutesName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RoutesName.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const BlankScreen());
    }
  }

}